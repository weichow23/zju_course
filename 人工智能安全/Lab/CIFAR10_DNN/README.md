> 本部分来源于网上

## Start training the model

### Define Neural Network Model

该项目采用由牛津大学VGG(Visual Geometry Group)组于2014年ILSVRC提出的VGG神经网络。VGG神经模型的核心是五组卷积操作，每两组之间做Max-Pooling空间降维。同一组内采用多次连续的3X3卷积，卷积核的数目由较浅组的64增多到最深组的512，同一组内的卷积核数目是一样的。卷积之后接两层全连接层，之后是分类层。由于每组内卷积层的不同，有11、13、16、19层这几种模型，在本章文章中使用到的是VGG16。VGG神经网络也是在ImageNet上首次公开超过人眼识别的模型。

这个VGG不是原来设的VGG神经模型,由于CIFAR10图片大小和数量相比ImageNet数据小很多，因此这里的模型针对CIFAR10数据做了一定的适配，卷积部分引入了`BN`层和`Dropout`操作。
`cnov_with_batchnorm`可以设置是否说明使用`BN`层。`BN`层全程为:`Batch Normalization`,在没有使用`BN`层之前:

- 参数的更新，使得每层的输入输出分布发生变化，称作ICS（Internal Covariate Shift）
- 差异会随着网络深度增大而增大
- 需要更小的学习率和较好的参数进行初始化

加入`BN`层之后:

- 可以使用较大的学习率
- 可以减少对参数初始化的依赖
- 可以拟制梯度的弥散
- 可以起到正则化的作用
- 可以加速模型收敛速度

于`vgg.py`中定义了VGG神经网络模型，然后于`train.py`训练代码

### Import Package Dependency

首先要先导入依赖包,其中就包含了最重要的PaddlePaddle的V2包

```
import sys
import paddle.v2 as paddle
from PIL import Image
import numpy as np
import os
```

### Initialize Paddle

创建一个新类，并在其中初始化函数中是初始化PaddlePaddle

```
class TestCIFAR:
    # ***********************Initialize**************************
    def __init__(self):
        # 1. initialize paddpaddle
        # 2. only use CPU, turn off GPU
        paddle.init(use_gpu=False, trainer_count=2)

```

### Obtain Parameter

训练参数可以通过使用损失函数创建一个训练参数，也可以通过使用之前训练好的参数初始化训练参数，使用训练好的参数来初始化训练参数，不仅可以使用之前的训练好的参数作为在此之上再继续训练，而且在某种情况下还防止出现浮点异常，比如SSD神经网络很容易出现浮点异常，就可以使用预训练的参数作为初始化训练参数，来解决出现浮点异常的问题。

该函数可以通过输入是否是参数文件路径，或者是损失函数，如果是参数文件路径，就使用之前训练好的参数生产参数。如果不传入参数文件路径,那就使用传入的损失函数生成参数。


### Create Trainer

创建训练器要3个参数,分别是损失函数,参数,优化方法.通过图像的标签信息和分类器生成损失函数。

参数可以选择是使用之前训练好的参数,然后在此基础上再进行训练,又或者是使用损失函数生成初始化参数。

然后再生成优化方法.就可以创建一个训练器了.

### Start Tranning

要启动训练要4个参数,分别是训练数据,训练的轮数,训练过程中的事件处理,输入数据和标签的对应关系.

训练数据:PaddlePaddle已经有封装好的API,可以直接获取CIFAR的数据.

训练轮数:表示我们要训练多少轮,次数越多准确率越高,最终会稳定在一个固定的准确率上.不得不说的是这个会比MNIST数据集的速度慢很多

事件处理:训练过程中的一些事件处理,比如会在每个batch打印一次日志,在每个pass之后保存一下参数和测试一下测试数据集的预测准确率.

输入数据和标签的对应关系:说明输入数据是第0维度,标签是第1维度

-----------------------

编写好代码，就可以在`main`函数中调用该函数开始训练,在训练过程中会输出这样的日志:

```
Pass 0, Batch 0, Cost 2.427227, {'classification_error_evaluator': 0.8984375}
...................................................................................................
Pass 0, Batch 100, Cost 2.115308, {'classification_error_evaluator': 0.78125}
...................................................................................................
Pass 0, Batch 200, Cost 2.081666, {'classification_error_evaluator': 0.8359375}
...................................................................................................
Pass 0, Batch 300, Cost 1.866330, {'classification_error_evaluator': 0.734375}
..........................................................................................
Test with Pass 0, {'classification_error_evaluator': 0.8687999844551086}
```

我们还可以使用PaddlePaddle提供的可视化日志输出接口`paddle.v2.plot`，以折线图的方式显示`Train cost`和`Test cost`，不过这个程序要在jupyter笔记本上运行。折线图如下，折线图如下，这张图是训练的56个pass之后的收敛情况。这个过程笔者为了使训练速度更快，笔者使用了2个GPU进行训练，训练56个pass共消耗6个小时，几乎已经完全收敛了:

![3.png](https://i.loli.net/2021/10/15/7rVgIYTZszGAHlt.png)

此时它测试输出的日志如下，可以看到看到预测错误率为`0.147799998528048`:
`Test with Pass 56, {'classification_error_evaluator': 0.1477999985218048}`

## Use Parameters to predict

编写一个`infer.py`的Python程序文件编写下面的代码,用于测试数据。 

在PaddlePaddle使用之前，都要初始化PaddlePaddle。

```
def __init__(self):
    paddle.init(use_gpu=False, trainer_count=2)
```

然后加载训练是保存的模型，从保存的模型文件中读取模型参数。

```
def get_parameters(self, parameters_path):
    with open(parameters_path, 'r') as f:
        parameters = paddle.parameters.Parameters.from_tar(f)
    return parameters
```


该函数需要输入3个参数:

- 第一个是需要预测的图像,图像传入之后,会经过`load_image`函数处理,大小会变成32*32大小,训练是输入数据的大小一样.
- 第二个就是训练好的参数
- 第三个是通过神经模型生成的分类器

在`main`入口中调用预测函数:

```
if __name__ == '__main__':
    testCIFAR = TestCIFAR()
    out = testCIFAR.get_out(3 * 32 * 32)
    parameters = testCIFAR.get_parameters("../model/model.tar")
    image_path = "../images/airplane1.png"
    result,probability = testCIFAR.to_prediction(image_path=image_path, out=out, parameters=parameters)
    print '预测结果为:%d,可信度为:%f' % (result,probability)

```

输出的预测结果是:

`预测结果为:0,可信度为:0.965155`

