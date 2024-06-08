# ADS_LJF_P1

本工程结构如下
```
-----Books
    |--存放莎士比亚全集的文本文件

-----SearchKey
    |--存放从莎士比亚全集中读取出来的索引词

-----lib
    |--util
        hash.h
        string_view.h
    porter2_stemmer.cpp
    porter2_stemmer.h

-----src
    main_multi_index.cpp
    main_single_index.cpp
    main.cpp
    Search.cpp
    stop_words.cpp

Makefile
README.md
```
进入本工程之后执行
```
$ make
```
即可得到三个可执行文件 `BuildDictionary`, `Search`, `StopWord` 三个可执行程序。（请注意这一步建议有 `gcc v8.4` 及以上的版本以支持 `filesystem`）

* 第一步，为已存在的词典建立索引，这一步需要较长时间
```
$ .\BuildDictionary
```

* 第二步，检测出停止词，阈值为最常出现的100个单词
```
$ .\StopWord
```

* 第三步，就可以开始执行我们的检索程序。开始运行后你可以输入一个单词或者几个单词，或者是句子，程序会给出这些词共同出现的文件集合。
```
$ .\Search
```

for test the search time:

```shell
$  ./test.sh test.txt
```

