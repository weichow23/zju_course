# coding:utf-8
import os
import sys
import paddle.v2 as paddle
from vgg import vgg_bn_drop
from resnet import resnet_cifar10

class TestCIFAR:
    # ***************************Initialize***********************************
    def __init__(self):
        # initialize paddpaddle
        # only use CPU, turn off GPU
        paddle.init(use_gpu=False, trainer_count=2)

    # *************************Gain Parameter*********************************
    def get_parameters(self, parameters_path=None, cost=None):
        if not parameters_path:
            # use cost create parameters
            if not cost:
                print "please cost parameter"
            else:
                # according to loss function, creating parameter
                parameters = paddle.parameters.create(cost)
                return parameters
        else:
            # use trained parameter
            try:
                # use trained parameter
                with open(parameters_path, 'r') as f:
                    parameters = paddle.parameters.Parameters.from_tar(f)
                return parameters
            except Exception as e:
                raise NameError("your parameter file wrong,the concrete issue:%s" % e)

    # ***************************Gain Trainer*********************************
    def get_trainer(self):
        # size of data
        datadim = 3 * 32 * 32

        # gain information label
        lbl = paddle.layer.data(name="label",
                                type=paddle.data_type.integer_value(10))

        # full layer
        out = vgg_bn_drop(datadim=datadim)
        # out = resnet_cifar10(datadim=datadim)

        # loss function
        cost = paddle.layer.classification_cost(input=out, label=lbl)

        # obtain parameter
        # parameters = self.get_parameters(parameters_path="../model/model.tar")
        # loss funciton to create parameters
        parameters = self.get_parameters(cost=cost)

        '''       Define optimize method
        learning_rate 
        momentum
        regularzation
        '''
        momentum_optimizer = paddle.optimizer.Momentum(
            momentum=0.9,
            regularization=paddle.optimizer.L2Regularization(rate=0.0002 * 128),
            learning_rate=0.1 / 128.0,
            learning_rate_decay_a=0.1,
            learning_rate_decay_b=50000 * 100,
            learning_rate_schedule="discexp")

        '''
        Create trainer
        cost 
        parameters 
        update_equation 
        '''
        trainer = paddle.trainer.SGD(cost=cost,
                                     parameters=parameters,
                                     update_equation=momentum_optimizer)
        return trainer

    # ***************************train***************************************
    def start_trainer(self):
        # obtain data
        reader = paddle.batch(reader=paddle.reader.shuffle(reader=paddle.dataset.cifar.train10(),
                                                           buf_size=50000),
                              batch_size=128)

        feeding = {"image": 0, "label": 1}

        # define event_handler
        # output log
        def event_handler(event):
            if isinstance(event, paddle.event.EndIteration):
                if event.batch_id % 100 == 0:
                    print "\nPass %d, Batch %d, Cost %f, %s" % (
                        event.pass_id, event.batch_id, event.cost, event.metrics)
                else:
                    sys.stdout.write('.')
                    sys.stdout.flush()

            if isinstance(event, paddle.event.EndPass):
                # save trained parameter
                model_path = '../model'
                if not os.path.exists(model_path):
                    os.makedirs(model_path)
                with open(model_path + '/model.tar', 'w') as f:
                    trainer.save_parameter_to_tar(f)

                # test accuracy rate
                result = trainer.test(reader=paddle.batch(reader=paddle.dataset.cifar.test10(),
                                                          batch_size=128),
                                      feeding=feeding)
                print "\nTest with Pass %d, %s" % (event.pass_id, result.metrics)

        # obtain trainer
        trainer = self.get_trainer()

        '''
        Start
        reader 
        num_passes 
        event_handler 
        feeding 
        '''
        trainer.train(reader=reader,
                      num_passes=100,
                      event_handler=event_handler,
                      feeding=feeding)

if __name__ == '__main__':
    testCIFAR = TestCIFAR()
    # start train
    testCIFAR.start_trainer()
