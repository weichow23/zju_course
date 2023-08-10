from PIL import Image
import random

def modify_image(image_path):
    # 打开图像
    image = Image.open(image_path+'.jpeg')
    width, height = image.size

    # 确定要修改的像素数量
    num_pixels = random.randint(200, 500)

    for _ in range(num_pixels):
        # 随机选择一个像素位置
        x = random.randint(0, width - 1)
        y = random.randint(0, height - 1)

        # 随机选择一个色道
        channel = random.randint(0, 2)  # 0表示红色通道，1表示绿色通道，2表示蓝色通道

        # 获取该像素的颜色值
        pixel = image.getpixel((x, y))
        r, g, b = pixel

        # 随机选择一个修改的相对值
        modification_percent = random.uniform(0.1, 2)  # 修改范围在0.8倍到1.2倍之间

        # 修改对应的色道值
        if channel == 0:
            r = int(r * modification_percent)
        elif channel == 1:
            g = int(g * modification_percent)
        elif channel == 2:
            b = int(b * modification_percent)

        # 设置修改后的像素值
        new_pixel = (r, g, b)
        image.putpixel((x, y), new_pixel)

    # 保存修改后的图像
    modified_image_path = 'm_' + image_path + '.png'
    image.save(modified_image_path)

for i in range(1,7):
    modify_image(str(i))
