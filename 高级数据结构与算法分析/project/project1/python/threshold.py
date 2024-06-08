import pandas as pd
import matplotlib.pyplot as plt

# 读取csv文件
df = pd.read_csv('threshold.csv', index_col=0)

# 提取均值和标准差数据
mean_values = df.loc['mean']
std_values = df.loc['std']

# 提取列名作为x轴标签
x_labels = mean_values.index.astype(float)

# 绘制折线图
plt.figure(figsize=(10, 6))
plt.plot(x_labels, mean_values, marker='o', color='b', label='Mean')

# 绘制色带
plt.fill_between(x_labels, mean_values - std_values, mean_values + std_values, color='skyblue', alpha=0.4, label='Standard Deviation')

# 添加标题和标签
plt.title('Threshold Data')
plt.xlabel('Threshold')
plt.ylabel('Value')

# 添加图例
plt.legend()

# 显示图形
plt.grid(True)
plt.savefig('std')
