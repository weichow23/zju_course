#!/bin/bash

# 创建data目录
mkdir -p data

# 编译gen_data_in.cpp
g++ -o gen_data_in gen_data_in.cpp
if [ $? -ne 0 ]; then
    echo "编译 gen_data_in.cpp 失败"
    exit 1
fi

# 运行gen_data_in生成数据
./gen_data_in
if [ $? -ne 0 ]; then
    echo "运行 gen_data_in 失败"
    exit 1
fi

# 编译skiplist.cpp
g++ -o skiplist skiplist.cpp
if [ $? -ne 0 ]; then
    echo "编译 skiplist.cpp 失败"
    exit 1
fi

# 运行skiplist
./skiplist
if [ $? -ne 0 ]; then
    echo "运行 skiplist 失败"
    exit 1
fi
