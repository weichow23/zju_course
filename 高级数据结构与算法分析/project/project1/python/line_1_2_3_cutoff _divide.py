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
x = range(num - 1)  # 由于计算增长速度后会少一个值，因此调整横坐标范围
y1 = df_sorted.iloc[:num, 1]  # 第2列为Article
y2 = df_sorted.iloc[:num, 2]  # 第3列为Count

# 计算增长速度
growth_rate1 = (- y2.shift(-1) + y2)
growth_rate2 = (- y2.shift(-1) + y2) / y2

# 创建图形和坐标轴对象
fig, ax1 = plt.subplots()

# 绘制第一个增长速度曲线
ax1.scatter(x, growth_rate1[:-1], color='red', alpha=0.5, s=12)
ax1.set_ylabel('Absolute Growth Rate', color='red')
ax1.tick_params(axis='y', labelcolor='red')

# 创建第二个坐标轴对象
ax2 = ax1.twinx()
# 绘制第二个增长速度曲线
ax2.scatter(x, growth_rate2[:-1], color='blue', alpha=0.5, s=12)
ax2.set_ylabel('Relative Growth Rate', color='blue')
ax2.tick_params(axis='y', labelcolor='blue')

plt.xlabel('Index')
plt.legend(loc='upper left')
plt.savefig('Growth_Rate.png')
plt.show()
