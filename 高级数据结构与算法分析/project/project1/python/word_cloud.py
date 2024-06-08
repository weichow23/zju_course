import pandas as pd
from wordcloud import WordCloud
import matplotlib.pyplot as plt
df = pd.read_csv('stats.csv', delimiter=',')

name='Count'

print(df.keys())
word_count = dict(zip(df['Word'], df[name]))
# 创建词云对象
wordcloud = WordCloud(width=800, height=400, background_color='white').generate_from_frequencies(word_count)
# 绘制词云图
plt.figure(figsize=(10, 5))
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis('off')
plt.savefig(name)
