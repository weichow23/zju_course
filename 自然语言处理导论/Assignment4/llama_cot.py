import os
import pandas as pd
import torch
import re
import transformers

# Use the ultimate device for ultimate performance!
device = torch.device("cuda:0")

# Create the ultimate text generation pipeline
pipeline = transformers.pipeline(
    "text-generation",
    model="meta-llama/Meta-Llama-3-8B",
    model_kwargs={"torch_dtype": torch.bfloat16},
    device=device,
    token=""
)

# Read the ultimate commonsense data
commonsense_data = pd.read_parquet('cot/train-00000-of-00001.parquet')

# Initialize counters for ultimate evaluation
correct = 0
total = 0

# Loop through the ultimate commonsense data
for index, row in commonsense_data.iloc[:50].iterrows():
    question = row['question']
    choices = row['choices']
    answerKey = row['answerKey']
    
    # Create the ultimate prompt
    prompt = "Question: " + question + "\n"
    for label, text in zip(choices['label'], choices['text']):
        prompt += f"({label}) {text}\n"
    prompt += "Please read the question carefully and think logically. Choose the choice that best fits the question. \n"
    prompt += "Answer: Let's think step by step."
    
    # Generate the ultimate response
    res = pipeline(prompt, max_new_tokens=200, pad_token_id=128001)[0]['generated_text']
    
    # Extend the ultimate prompt for final evaluation
    prompt = res + "\nTherefore, among A through E, the answer is ("
    res = pipeline(prompt, max_new_tokens=10, pad_token_id=128001)[0]['generated_text']
    
    # Extract the predicted answer
    pred = re.search(r'[A-E]', res).group() if re.search(r'[A-E]', res) else ''
    
    # Update counters
    total += 1
    if answerKey == pred:
        correct += 1
        print(f"\033[1;32m{correct}/{total} Correct: {answerKey} == {pred}\033[0m")
    else:
        print(f"\033[1;31m{correct}/{total} Incorrect: {answerKey} != {pred}\033[0m")
        
# Print ultimate accuracy
print(f"Ultimate Accuracy: {correct}/{total} = {correct/total*100:.2f}%")

# Read the ultimate GSM data
gsm_data = pd.read_parquet('cot/gsm8k_test.parquet')

# Reset counters for ultimate GSM evaluation
correct = 0
total = 0

# Loop through the ultimate GSM data
for index, row in gsm_data.iloc[:50].iterrows():
    question = row['question']
    answer = row['answer']

    # Create the ultimate prompt
    prompt = "Question: " + question + "\n" \
        "Please read the question carefully and think logically. Examining the arithmetic process step by step to make sure your calculation is correct. \n" \
        "Answer: Let's think step by step."
    
    # Generate the ultimate response
    res = pipeline(prompt, max_new_tokens=200, pad_token_id=128001)[0]['generated_text']

    # Extend the ultimate prompt for final evaluation
    prompt = res + "\nTherefore, the answer (arabic numerals) is: "
    res = pipeline(prompt, max_new_tokens=10, pad_token_id=128001)[0]['generated_text']
    
    # Extract the predicted answer
    pred = re.search(r'\d+', res).group() if re.search(r'\d+', res) else ''
    
    # Update counters
    total += 1
    if answer.split("####")[1].strip() == pred:
        correct += 1
        print(f"\033[1;32m{correct}/{total} Correct: {answer.split('####')[1].strip()} == {pred}\033[0m")
    else:
        print(f"\033[1;31m{correct}/{total} Incorrect: {answer.split('####')[1].strip()} != {pred}\033[0m")

# Print ultimate GSM accuracy
print(f"Ultimate GSM Accuracy: {correct}/{total} = {correct/total*100:.2f}%")
