import pandas as pd
import matplotlib.pyplot as plt

# 读取CSV文件
df = pd.read_csv('stats.csv', delimiter=',')

# 提取第2列和第3列的值
x = df.index  # 使用行索引作为x轴
y1 = df.iloc[:, 1]  # 第2列为Count
y2 = df.iloc[:, 2]  # 第3列为Sum

# 绘制两条曲线

plt.scatter(x, y2, label='Count', alpha=0.6, s=5)
plt.scatter(x, y1, label='Article', alpha=0.2, s=5)
plt.xlabel('Index')
plt.ylabel('Value')
plt.legend()
plt.savefig('Count_vs_Article.png')
plt.show()
