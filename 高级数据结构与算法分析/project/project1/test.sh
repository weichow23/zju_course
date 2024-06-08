#!/bin/bash

# 检查是否提供了输入文件作为参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# 输入文件
input_file="$1"

# 确保输入文件存在
if [ ! -f "$input_file" ]; then
    echo "Input file does not exist."
    exit 1
fi

# 初始化变量
total_ticks=0
word_count=0

# 逐行读取输入文件
while IFS= read -r line; do
    # 运行Search命令，获取输出
    output=$(./Search <<< "$line")
    # 提取tick前的数字
    ticks=$(echo "$output" | grep -oP 'Duration: \K\d+')
    # 累加时间
    total_ticks=$((total_ticks + ticks))
    # 单词计数
    word_count=$((word_count + 1))
done < "$input_file"

# 计算平均时间
if [ $word_count -gt 0 ]; then
    average_ticks=$((total_ticks / word_count))
    echo "Average duration: $average_ticks ticks"
else
    echo "No words found."
fi
