
import models, torch
import matplotlib as plt


class Server(object):
	
	def __init__(self, conf, eval_dataset):
	
		self.conf = conf 
		
		self.global_model = models.get_model(self.conf["model_name"]) 
		
		self.eval_loader = torch.utils.data.DataLoader(eval_dataset, batch_size=self.conf["batch_size"], shuffle=True)

		self.train_loss_values = []
		self.valid_acc_values = []
		self.valid_loss_values = []
	
	def model_aggregate(self, weight_accumulator,avg_train_loss):
		for name, data in self.global_model.state_dict().items():
			
			update_per_layer = weight_accumulator[name] * self.conf["lambda"]
			
			if data.type() != update_per_layer.type():
				data.add_(update_per_layer.to(torch.int64))
			else:
				data.add_(update_per_layer)
		self.train_loss_values.append(avg_train_loss)
				
	def model_eval(self):
		self.global_model.eval()
		
		total_loss = 0.0
		correct = 0
		dataset_size = 0
		for batch_id, batch in enumerate(self.eval_loader):
			data, target = batch 
			dataset_size += data.size()[0]
			# expand the channel of MNIST data from 1 to 3
			# data = data.expand(-1,3,-1,-1)
			
			if torch.cuda.is_available():
				data = data.cuda()
				target = target.cuda()
				
			
			output = self.global_model(data)
			
			total_loss += torch.nn.functional.cross_entropy(output, target, reduction='sum').item() # sum up batch loss
			pred = output.data.max(1)[1]  # get the index of the max log-probability
			correct += pred.eq(target.data.view_as(pred)).cpu().sum().item()

		acc = 100.0 * (float(correct) / float(dataset_size))
		total_l = total_loss / dataset_size
		self.valid_acc_values.append(acc)
		self.valid_loss_values.append(total_l)

		return acc, total_l

	def plot_metrics(self):
		fig, ax1 = plt.subplots()

		color = 'tab:red'
		ax1.set_xlabel('Epochs')
		ax1.set_ylabel('Loss', color=color)
		ax1.plot(self.train_loss_values, color=color)
		ax1.plot(self.valid_loss_values, color='tab:orange')
		ax1.tick_params(axis='y', labelcolor=color)

		ax2 = ax1.twinx()
		color = 'tab:blue'
		ax2.set_ylabel('Accuracy', color=color)
		ax2.plot(self.valid_acc_values, color=color)
		ax2.tick_params(axis='y', labelcolor=color)

		fig.tight_layout()
		plt.show()