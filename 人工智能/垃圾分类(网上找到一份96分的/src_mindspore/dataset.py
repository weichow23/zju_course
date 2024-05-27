"""
create train or eval dataset.
"""
import os
import mindspore as ms
from mindspore.dataset.transforms import c_transforms as C2

from mindspore.dataset import ImageFolderDataset
from mindspore.dataset.vision import c_transforms as C

def create_dataset(config, training=True, buffer_size=1000, repeat=1):
    """
    create a train or eval dataset

    Args:
        config(struct): the config of train and eval in diffirent platform.
        dataset_path(string): the path of dataset.
        training(bool): training or eval

    Returns:
        train_dataset, val_dataset
    """
    data_path = os.path.join(config.dataset_path, 'train' if training else 'val')
    ds = ImageFolderDataset(data_path, num_parallel_workers=4, class_indexing=config.class_index)
    resize_height = config.image_height
    resize_width = config.image_width
    
    # define operations mapping to each sample
    normalize_op = C.Normalize(mean=[0.485*255, 0.456*255, 0.406*255], std=[0.229*255, 0.224*255, 0.225*255])
    change_swap_op = C.HWC2CHW()
    type_cast_op = C2.TypeCast(ms.int32)

    if training:
        # operations for training
        crop_decode_resize = C.RandomCropDecodeResize(resize_height, scale=(0.08, 1.0), ratio=(0.75, 1.333))
        horizontal_flip_op = C.RandomHorizontalFlip(prob=0.5)
        color_adjust = C.RandomColorAdjust(brightness=0.4, contrast=0.4, saturation=0.4)
    
        train_trans = [crop_decode_resize, horizontal_flip_op, color_adjust, normalize_op, change_swap_op]
        train_ds = ds.map(input_columns="image", operations=train_trans, num_parallel_workers=4)
        train_ds = train_ds.map(input_columns="label", operations=type_cast_op, num_parallel_workers=4)
        
        # apply shuffle operations
        train_ds = train_ds.shuffle(buffer_size=buffer_size)
        # apply batch operations
        ds = train_ds.batch(config.batch_size, drop_remainder=True)
        ds = ds.repeat(repeat)
    else:
        # operations for inference
        decode_op = C.Decode()
        resize_op = C.Resize((int(resize_width/0.875), int(resize_width/0.875)))
        center_crop = C.CenterCrop(resize_width)
        
        eval_trans = [decode_op, resize_op, center_crop, normalize_op, change_swap_op]
        eval_ds = ds.map(input_columns="image", operations=eval_trans, num_parallel_workers=4)
        eval_ds = eval_ds.map(input_columns="label", operations=type_cast_op, num_parallel_workers=4)
        ds = eval_ds.batch(config.eval_batch_size, drop_remainder=True)

    return ds
