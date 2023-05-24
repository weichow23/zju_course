import argparse, json
import datetime
import os
import logging
import torch, random

from server import *
from client import *
import models, datasets

	
# 本次上机实验为本地模拟联邦学习过程，需一至两小时的训练时间
# run with configuration
# python main.py -c ./utils/conf.json

# 各个文件的简要介绍
# ./utils/conf.json 提供参数配置，如数据集选择、模型选择、客户端数量、抽样数量等
# datasets.py 提供mnist和cifar数据集（已经下载在data文件夹中）
# models.py 提供若干模型
# server.py 为服务端，即整合各客户端模型
# client.py 为客户端，即本地训练模型


if __name__ == '__main__':

	parser = argparse.ArgumentParser(description='Federated Learning')
	parser.add_argument('-c', '--conf', dest='conf')
	args = parser.parse_args()
	

	with open(args.conf, 'r') as f:
		conf = json.load(f)	
	
	
	train_datasets, eval_datasets = datasets.get_dataset("./data/", conf["type"])
	
	server = Server(conf, eval_datasets)
	clients = []
	
	for c in range(conf["no_models"]):
		clients.append(Client(conf, server.global_model, train_datasets, c))
		
	print("\n\n")
	for e in range(conf["global_epochs"]):
	
		candidates = random.sample(clients, conf["k"])
		
		weight_accumulator = {}
		
		for name, params in server.global_model.state_dict().items():
			weight_accumulator[name] = torch.zeros_like(params)
		
		for c in candidates:
			diff = c.local_train(server.global_model)
			
			for name, params in server.global_model.state_dict().items():
				weight_accumulator[name].add_(diff[name])
				
		
		server.model_aggregate(weight_accumulator)
		
		acc, loss = server.model_eval()
		
		print("Epoch %d, acc: %f, loss: %f\n" % (e, acc, loss))
				
			
		
		
	
		
		
	