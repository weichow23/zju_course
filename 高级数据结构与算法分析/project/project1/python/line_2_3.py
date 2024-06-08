import pandas as pd
import matplotlib.pyplot as plt

# 读取CSV文件
df = pd.read_csv('stats.csv', delimiter=',')

# 提取第2列和第3列的值
x = df.iloc[:, 1]
y = df.iloc[:, 2]

# 绘制散点图
plt.scatter(x, y, alpha=0.5)
plt.ylabel('Count')
plt.xlabel('Article')
plt.savefig('Count vs Article')
plt.show()
