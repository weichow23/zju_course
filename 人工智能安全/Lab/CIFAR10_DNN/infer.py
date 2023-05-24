# coding:utf-8
from paddle.v2.plot import Ploter
import sys
import paddle.v2 as paddle
from PIL import Image
import numpy as np
import os
from vgg import vgg_bn_drop

class TestCIFAR:
    # *************************Initialize*************************************
    def __init__(self):
        # initial paddpaddle
        # only use CPU, turn off GPU
        paddle.init(use_gpu=False, trainer_count=2)

    # **********************Obtain parameters*********************************
    def get_parameters(self, parameters_path):
        with open(parameters_path, 'r') as f:
            parameters = paddle.parameters.Parameters.from_tar(f)
        return parameters

    # **************************Forecast**************************************
    def to_prediction(self, image_path, parameters, out):
        # obtain picture
        def load_image(file):
            im = Image.open(file)
            im = im.resize((32, 32), Image.ANTIALIAS)
            im = np.array(im).astype(np.float32)
            # use PIL open picture
            # save as H(height)，W(width)，C(channel)。
            # PaddlePaddle need data order: CHW，so need change order
            im = im.transpose((2, 0, 1))
            # CIFAR  train pictures channel order:B(blue),G(green),R(red),
            # use PIL open pictrue, the default channel order:RGB, so need chage channel
            im = im[(2, 1, 0), :, :]  # BGR
            im = im.flatten()
            im = im / 255.0
            return im

        # obtain predicting picture
        test_data = []
        test_data.append((load_image(image_path),))

        # obtain predicting result
        probs = paddle.infer(output_layer=out,
                             parameters=parameters,
                             input=test_data)
        # precessing predicting result
        lab = np.argsort(-probs)
        # return highest probability and the value
        return lab[0][0], probs[0][(lab[0][0])]


if __name__ == '__main__':
    testCIFAR = TestCIFAR()
    # start forecast
    out = vgg_bn_drop(3 * 32 * 32)
    parameters = testCIFAR.get_parameters("../model/model.tar")
    image_path = "../images/airplane1.png"
    result,probability = testCIFAR.to_prediction(image_path=image_path, out=out, parameters=parameters)
    print 'forecast result:%d,credibility:%f' % (result,probability)
