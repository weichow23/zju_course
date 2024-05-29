import matplotlib.pyplot as plt

file_path = 'output.txt'
with open(file_path, 'r') as file:
    lines = file.readlines()

losses = []
epoch = 1
epoch_losses = []
for line in lines:
    if f'epoch: {epoch + 1}' in line:
        losses.append(epoch_losses)
        epoch_losses = []
        epoch += 1
    loss_start = line.find('[')
    loss_end = line.find(']')
    if loss_start != -1 and loss_end != -1:
        loss = float(line[loss_start + 1:loss_end])
        epoch_losses.append(loss)

losses.append(epoch_losses)

# 绘制loss曲线
plt.figure(figsize=(10, 6))
for i, loss in enumerate(losses):
    epochs = list(range(1, len(loss) + 1))
    plt.plot(epochs, loss, label=f'epoch {i + 1}')
plt.title('Training Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.legend()
plt.grid(True)
plt.savefig('epoch')
