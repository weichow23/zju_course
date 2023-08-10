import random
from PIL import Image

def color_segmentation(pixel):
    # 定义分段函数规则
    if pixel <= 51:
        return 0
    elif pixel <= 102:
        return 1
    elif pixel <= 153:
        return 2
    elif pixel <= 204:
        return 3
    else:
        return 4

def process_image(image_path):
    # 打开图片
    image = Image.open(image_path+".jpeg")
    width, height = image.size
    # 创建新的图片对象
    processed_image = Image.new("RGB", (width, height))
    # 遍历每个像素点
    for y in range(height):
        for x in range(width):
            # 获取原始像素值
            r, g, b = image.getpixel((x, y))
            # 随机选择一种颜色并设置其值，其余两个色道为0
            random_color = random.choice(['R', 'G', 'B'])
            if random_color == 'R':
                r = color_segmentation(r)
                g, b = 255, 255
            elif random_color == 'G':
                g = color_segmentation(g)
                r, b = 255, 255
            else:
                b = color_segmentation(b)
                r, g = 255, 255
            processed_image.putpixel((x, y), (r, g, b))
    processed_image.save(image_path+".png")
# 运行程序
for i in range(1,7):
    process_image(str(i))