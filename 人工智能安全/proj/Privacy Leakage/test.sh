# generate
python main.py \
    --inet-dir ImageNet \
    --gpu 6 7 \
    --expr rep_recover_acc \
    --batch-size 16 \
    --num-samples-per-class 1 \
    --num-batches 1 \
    --arch resnet50 \
    --eps 3     # 0 for vanilla and 3 for AT

# test
python main.py \
    --inet-dir ImageNet \
    --gpu 6 7 \
    --expr img_recover \
    --arch resnet50 \
    --eps 3 \
    --batch-size 16 \
    --opt adam \
    --lr 0.1 \
    --steps 5000 \
    --tv-l2-reg 1e-6 \
    --restarts 5 \
    --use-best