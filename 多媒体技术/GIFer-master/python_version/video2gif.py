from gifer import GifWriter
from v2p import V2P
import numpy as np
from PIL import Image
import numpy as np
from scipy.cluster.vq import vq
import colorsys
import random
import math
from PIL.GifImagePlugin import getheader, getdata
import binascii
import struct

BUF_SIZE = 4294967296

class Vid2Gif(object):
    def __init__(self, vid_file, cut = False, st="00:00:00", et="00:00:00", rate=10):
        super(Vid2Gif, self).__init__()
        self.v2p = V2P(vid_file, cut, st, et, rate)
        self.width = 0
        self.height = 0
        self.frames = None
        self.global_raw_palette = self.generate_palette(256)
        self.global_palette = [self.combine_rgblist(x) for x in self.global_raw_palette]
        self.buf_ = np.zeros(BUF_SIZE)
        self.buf_ = self.buf_.astype(dtype=np.uint8)
        self.gf = None
        self.opts = {'palette': self.global_palette, 'loop': 0}
        self.useGlobalPalette = False
        self.color_indices = None

    @staticmethod
    def generate_palette(N):
        HSV_tuples = [(x * 1.0 / N, 0.5, 0.5) for x in range(N)]
        RGB_tuples = map(lambda x: colorsys.hsv_to_rgb(*x), HSV_tuples)
        result = []
        for x in RGB_tuples:
            r = int(x[0] * 255)
            g = int(x[1] * 255)
            b = int(x[2] * 255)
            result.append([r, g, b])
        return result

    @staticmethod
    def combine_rgb(r, g, b):
        return r << 16 | g << 8 | b

    @staticmethod
    def combine_rgblist(rgb):
        return rgb[0] << 16 | rgb[1] << 8 | rgb[0]

    @staticmethod
    def quantize(pixels, palette):
        """quantize an image with a given color palette"""
        # pixels = np.reshape(img, (img.shape[0] * img.shape[1], 3))
        qnt, _ = vq(pixels, palette)
        centers_idx = np.reshape(qnt, (pixels.shape[0]))
        return centers_idx

    def quantize2(self, pixels, palette):
        return [self.color_map(x) for x in pixels]

    def set_config(self, opt_key, opt_value):
        self.opts[opt_key] = opt_value

    def write_gfi_from_frame(self, gif_file):
        self.process_video()
        self.v2p.write_frame()
        self.gf = GifWriter(self.buf_, self.width, self.height, self.opts)

        frameCount = 0
        for f in self.frames:
            print("processing frame "+str(frameCount))
            frameCount += 1
            f = np.reshape(f, (f.shape[0] * f.shape[1], 3))
            f_tuple = [(x[0], x[1], x[2]) for x in f]
            im = Image.new("RGB", (self.width, self.height))
            im.putdata(f_tuple)
            indices = None
            palette = []
            if self.useGlobalPalette:
                indices = self.quantize(f, self.global_raw_palette)
            else:
                im = im.convert('P', palette=Image.ADAPTIVE, colors=256)
                indices = list(im.getdata())
                p = list(getheader(im)[0][-1])
                for i in range(0, len(p),3):
                    r,g,b = p[i],p[i+1],p[i+2]
                    int_r = int(r.encode('hex'), 16)
                    int_g = int(g.encode('hex'), 16)
                    int_b = int(b.encode('hex'), 16)
                    palette.append( self.combine_rgb(int_r,int_g,int_b))
            opts = self.opts
            opts['palette'] = palette
            self.gf.add_frame(0, 0, self.width, self.height, indices, {'palette': palette})
        end = self.gf.gif_end()
        with open(gif_file, 'wb') as f:
            f.write(self.buf_[:end])
            

    def write_gif_frome_bmp(self, gif_file):
        self.process_video()
        self.v2p.write_frame()
        self.gf = GifWriter(self.buf_, self.width, self.height, self.opts)
        for i in range(0, 25):
            f = './temp/frame'+str(i)+'.bmp'
            print("Processing file"+f)
            im = Image.open(f)
            im = im.convert('P', palette=Image.ADAPTIVE, colors=256)
            indices = list(im.getdata())
            p = list(getheader(im)[0][-1])
            palette = []
            for i in range(0, len(p),3):
                r,g,b = p[i],p[i+1],p[i+2]
                int_r = int(r.encode('hex'), 16)
                int_g = int(g.encode('hex'), 16)
                int_b = int(b.encode('hex'), 16)
                palette.append( self.combine_rgb(int_r,int_g,int_b))
            self.gf.add_frame(0, 0, self.width, self.height, indices, {'palette': palette})
        end = self.gf.gif_end()
        with open(gif_file, 'wb') as f:
            f.write(self.buf_[:end])


    def write_gif(self, gif_file = 'ouput.gif', direct_from_memory = False):
        if direct_from_memory:
            self.write_gfi_from_frame(gif_file)
        else:
            self.write_gif_frome_bmp(gif_file)

    def process_video(self):
        print("Processing video, it should take a while...")
        self.v2p.fetch()
        print("Preparing writting GIF....")
        self.width = int(self.v2p.width)
        self.height = int(self.v2p.height)
        self.frames = self.v2p.frames












