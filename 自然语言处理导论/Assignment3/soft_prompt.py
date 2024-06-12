import os
import math
from pathlib import Path

import torch
from torch.utils.data import Dataset, DataLoader
import torch.nn as nn
import torch.nn.functional as F
from transformers import AutoTokenizer, RobertaForSequenceClassification, RobertaConfig
from easydict import EasyDict
import tqdm

# Configuration settings
cfg = EasyDict({
    'name': 'movie review',
    'pre_trained': False,
    'num_classes': 2,
    'batch_size': 64,
    'epoch_size': 50,
    'weight_decay': 3e-5,
    'data_path': './data/',
    'device_target': 'cuda',  # Changed to 'cuda' for consistency
    'device_id': 0,
    'keep_checkpoint_max': 1,
    'checkpoint_path': './ckpt/train_textcnn-4_149.ckpt',
    'word_len': 51,
    'vec_length': 40,
    'soft_prompt_length': 10    # the length of soft prompt
})

class MovieReviewDataset(Dataset):
    def __init__(self, root_dir, maxlen, split, task, tokenizer):
        self.path = root_dir
        self.feel_map = {'neg': 0, 'pos': 2}  # in RoBERTa, 2 is positive
        self.files = []

        if not Path(self.path).exists() or not Path(self.path).is_dir():
            raise ValueError(f'{self.path} is not a directory')

        for root, _, filenames in os.walk(self.path):
            for file in filenames:
                self.files.append(os.path.join(root, file))
            break

        if len(self.files) != 2:
            raise ValueError(f'{self.path} should contain 2 files')

        self.tokenizer = tokenizer
        self.pos = []
        self.neg = []

        for file in self.files:
            self.read_data(file)

        self.pos_neg = self.pos + self.neg
        self.text2vec(maxlen=maxlen)
        self.split_dataset(split=split)
        self.task = task

    def read_data(self, file_path):
        with open(file_path, 'r') as f:
            for sentence in f.readlines():
                sentence = sentence.strip().translate(str.maketrans('', '', '"\'.,[]()--\\0123456789`=$/*;<b>%'))
                words = sentence.split()
                if words:
                    label = self.feel_map['pos'] if 'pos' in file_path else self.feel_map['neg']
                    (self.pos if 'pos' in file_path else self.neg).append([words, label])

    def text2vec(self, maxlen):
        for sentence_label in tqdm.tqdm(self.pos + self.neg, desc='text2vec'):
            sentence = ' '.join(sentence_label[0])
            tokens = self.tokenizer(sentence, padding='max_length', max_length=maxlen, truncation=True, return_tensors='pt')
            tokens['input_ids'] = torch.cat((torch.zeros((1, cfg.soft_prompt_length), dtype=torch.long), tokens['input_ids']), dim=1)
            tokens['attention_mask'] = torch.cat((torch.ones((1, cfg.soft_prompt_length), dtype=torch.long), tokens['attention_mask']), dim=1)
            sentence_label[0] = tokens

    def split_dataset(self, split):
        split_pos = math.ceil((1-split)*len(self.pos))
        split_neg = math.ceil((1-split)*len(self.neg))
        trunks_pos = [self.pos[i*split_pos:(i+1)*split_pos] for i in range(math.ceil(len(self.pos)/split_pos))]
        trunks_neg = [self.neg[i*split_neg:(i+1)*split_neg] for i in range(math.ceil(len(self.neg)/split_neg))]
        self.test = trunks_pos.pop(0) + trunks_neg.pop(0)
        self.train = [item for sublist in trunks_pos + trunks_neg for item in sublist]

    def __len__(self):
        return len(self.train) if self.task == 'train' else len(self.test)
        
    def __getitem__(self, idx):
        return self.train[idx] if self.task == 'train' else self.test[idx]

def collate_fn(batch):
    input_ids = torch.cat([data[0]['input_ids'] for data in batch], dim=0)
    attention_mask = torch.cat([data[0]['attention_mask'] for data in batch], dim=0)
    labels = torch.tensor([data[1] for data in batch])
    return {'input_ids': input_ids, 'attention_mask': attention_mask}, labels

tokenizer = AutoTokenizer.from_pretrained("cardiffnlp/twitter-roberta-base-sentiment-latest")

train_dataset = MovieReviewDataset(cfg.data_path, cfg.word_len, 0.9, 'train', tokenizer)
train_dataloader = DataLoader(train_dataset, batch_size=cfg.batch_size, shuffle=True, collate_fn=collate_fn)

test_dataset = MovieReviewDataset(cfg.data_path, cfg.word_len, 0.9, 'test', tokenizer)
test_dataloader = DataLoader(test_dataset, batch_size=cfg.batch_size, shuffle=True, collate_fn=collate_fn)

device = torch.device(cfg.device_target)

model = RobertaForSequenceClassification.from_pretrained("cardiffnlp/twitter-roberta-base-sentiment-latest")
model.to(device)

# Evaluate the original model
model.eval()
correct, total = 0, 0
with torch.no_grad():
    for data in tqdm.tqdm(test_dataloader, desc='test origin model'):
        x, y = data
        x = {k: v.to(device) for k, v in x.items()}
        y = y.to(device)
        outputs = model(**x, labels=y)
        _, predicted = torch.max(outputs.logits, 1)
        total += y.size(0)
        correct += (predicted == y).sum().item()
print(f'Accuracy of the network on the test data: {100 * correct / total:.2f}%')

# Freeze the model and set up the soft prompt
model.train()
for param in model.parameters():
    param.requires_grad = False

class SoftPromptWTE(nn.Module):
    def __init__(self, original_wte):
        super(SoftPromptWTE, self).__init__()
        self.original_wte = original_wte
        self.soft_prompt = nn.Parameter(torch.randn(cfg.soft_prompt_length, model.config.hidden_size))

    def forward(self, x):
        x = self.original_wte(x)
        x[:, :cfg.soft_prompt_length] = self.soft_prompt[None]
        return x

soft_prompt_wte = SoftPromptWTE(model.get_input_embeddings()).to(device)
model.set_input_embeddings(soft_prompt_wte)

if cfg.pre_trained:
    soft_prompt_wte.soft_prompt.data = torch.load('soft_prompt.pt')
else:
    optimizer = torch.optim.Adam(model.parameters(), lr=5e-2, weight_decay=cfg.weight_decay)
    scheduler = torch.optim.lr_scheduler.StepLR(optimizer, step_size=5, gamma=0.5)

    for epoch in range(cfg.epoch_size):
        model.train()
        epoch_loss = 0
        for data in tqdm.tqdm(train_dataloader, desc=f'epoch {epoch}'):
            x, y = data
            x = {k: v.to(device) for k, v in x.items()}
            y = y.to(device)
            optimizer.zero_grad()
            outputs = model(**x, labels=y)
            loss = outputs.loss
            loss.backward()
            optimizer.step()
            epoch_loss += loss.item()

        print(f'Epoch: {epoch}, LR: {scheduler.get_last_lr()}, Loss: {epoch_loss / len(train_dataloader):.4f}')
        scheduler.step()
        
        if (epoch + 1) % 5 == 0:
            model.eval()
            correct, total = 0, 0
            with torch.no_grad():
                for data in tqdm.tqdm(test_dataloader, desc=f'epoch {epoch} val'):
                    x, y = data
                    x = {k: v.to(device) for k, v in x.items()}
                    y = y.to(device)
                    outputs = model(**x, labels=y)
                    _, predicted = torch.max(outputs.logits, 1)
                    total += y.size(0)
                    correct += (predicted == y).sum().item()
            print(f'Accuracy on test data: {100 * correct / total:.2f}%')

# Save the soft prompt
torch.save(soft_prompt_wte.soft_prompt, 'soft_prompt.pt')

# Find most similar words in the vocabulary for soft prompt
vocab_embedding = model.get_input_embeddings().weight.data
soft_prompt = soft_prompt_wte.soft_prompt.data

vocab_embedding_norm = F.normalize(vocab_embedding, p=2, dim=-1)
soft_prompt_norm = F.normalize(soft_prompt, p=2, dim=-1)
similarity = torch.matmul(soft_prompt_norm, vocab_embedding_norm.T)
soft_prompt_ids = torch.argmax(similarity, dim=1)

print(tokenizer.decode(soft_prompt_ids))
