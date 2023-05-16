# Dataset
Cora dataset stored in `data.pth`:

```python
import torch

data = torch.load('data.pth')
g = data['g']
feat = data['feat']
label = data['label']
train_nodes = data['train_nodes']
val_nodes = data['val_nodes']
test_nodes = data['test_nodes']

```
NOTE: train: validation: test = 1: 1: 8

# Requirements
```bash
pip install -r requirements.txt
```

# Attack

对图结构和图节点特征进行扰动，使得模型分类错误

see `attack.ipynb`
FGAttack (FMSM) as in :
+ *Goodfellow et al.* [📝Explaining and Harnessing Adversarial Examples](https://arxiv.org/abs/1412.6572), *ICLR'15*
+ *Chen et al.* [📝Fast Gradient Attack on Network Embedding](https://arxiv.org/abs/1809.02797), *arXiv'18*
+ *Chen et al.* [📝Link Prediction Adversarial Attack Via Iterative Gradient Attack](https://ieeexplore.ieee.org/abstract/document/9141291), *IEEE Trans'20* 
+ *Dai et al.* [📝Adversarial Attack on Graph Structured Data](https://arxiv.org/abs/1806.02371), *ICML'18*

# 防御方案1：Data-based Defense 
see `data_defense.ipynb`
JaccardPurification as in *Wu et al.* [📝Adversarial Examples on Graph Data: Deep Insights into Attack and Defense](https://arxiv.org/abs/1903.01610), *IJCAI'19*

# 防御方案2：Model-based Defense
see `model_defense.ipynb`
MedianGCN as in *Chen et al.* [📝Understanding Structural Vulnerability in Graph Convolutional Networks](https://www.ijcai.org/proceedings/2021/310), *IJCAI'21*