import pandas as pd
import matplotlib.pyplot as plt

# 读取 CSV 文件
data = pd.read_csv("search_strategy.csv", delimiter=",")

# 提取数据列
multi = data["multi"]
single = data["single"]

# 创建折线图
plt.plot(multi, label="Multi")
plt.plot(single, label="Single")

# 添加标签和标题
plt.xlabel("Index")
plt.ylabel("Values")
plt.title("Search Strategy Comparison")

# 添加图例
plt.legend()

# 显示图形
plt.savefig('multi')
