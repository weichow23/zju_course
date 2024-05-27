from shutil import copyfile
import os

for i in range(6, 100):
    src = '03_02/'+str(i%5 + 1).zfill(5)+'.jpg'
    dst = '03_02/'+str(i).zfill(5)+'.jpg'
    copyfile(src, dst)
