import pandas as pd
import matplotlib.pyplot as plt

# 读取CSV文件
df = pd.read_csv('stats.csv', delimiter=',')

# 按第二列排序
df_sorted = df.sort_values(by=df.columns[2], ascending=False)

num = 200
# 选择第二列中前num个索引值
top_num_indices = df_sorted.iloc[:num].index

# 提取第2列和第3列的值
x = range(num)  # 匿名化的横坐标，从0到99
y1 = df_sorted.iloc[:num, 1]  # 第2列为Article
y2 = df_sorted.iloc[:num, 2]  # 第3列为Count

# 绘制两条曲线
plt.scatter(x, y2, label='Count', alpha=0.5, s=12)
plt.scatter(x, y1, label='Article', alpha=0.5, s=12)
plt.xlabel('Index')
plt.ylabel('Value')
plt.legend()
plt.savefig('Count_vs_Article_cutoff.png')
plt.show()
