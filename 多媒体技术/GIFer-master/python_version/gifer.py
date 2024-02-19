import numpy as np



class GifWriter(object):
    def __init__(self, buf_, width, height, opts):
        super(GifWriter, self).__init__()
        # if type(buf_) is not np.ndarray:
        #     raise ValueError("buf_ type is not numpy.ndarray")
        self.buf_ = buf_
        if width <= 0 or height <= 0 or width > 65535 or height > 65535:
            raise ValueError("invalid width and height")
        self.width = int(width)
        self.height = int(height)
        try:
            self.opts = opts
        except:
            self.opts = {}

        self.global_palette = self.opts.get('palette', None)
        self.loop_count = self.opts.get('loop', 0)
        self.delay = self.opts.get('delay', None)
        self.disposal = self.opts.get('disposal', None)
        self.transparent_index = self.opts.get('transparent', None)

        self.gif_ended = False
        self.ptr = 0
        self.cur_subblock = 0
        self.clear_code = 0
        self.code_mask = 0
        self.eoi_code = 0
        self.next_code = 0
        self.cur_code_size = 0
        self.cur_shift = 0
        self.cur = 0
        self.init_gif_format()

        self.frame_count = 0

    def fill_color_table(self, palette):
        for i in range(0, len(palette)):
            rgb = palette[i]
            self.assign_buf_(rgb >> 16 & 0xff)
            self.assign_buf_(rgb >> 8 & 0xff)
            self.assign_buf_(rgb & 0xff)

    def assign_buf_(self, value):
        """ assgin buffer and increment ptr"""
        if value is None:
            raise ValueError("assign_buf_:value is None")
        try:
            self.buf_[self.ptr] = np.uint8(value)
        except:
            self.buf_ = np.concatenate( (self.buf_, np.zeros(3145728) ) )
            # self.buf_ = np.append(self.buf_, np.zeros(1024))
            self.buf_[self.ptr] = np.uint8(value)
        self.ptr += 1
        return self.buf_[self.ptr - 1]

    def init_gif_format(self):
        # size of global color table in power2
        gp_num_colors_pow2 = 0
        background = 0
        if self.global_palette is not None:
            gp_num_colors = self.check_palette_and_num_colors(self.global_palette)
            gp_num_colors >>= 1
            while gp_num_colors:
                gp_num_colors_pow2 += 1
                gp_num_colors >>= 1
            gp_num_colors = 1 << gp_num_colors_pow2
            gp_num_colors_pow2 -= 1
            if self.opts.get('background',None) is not None:
                background = self.opts.get('background', 0)
                if background >= gp_num_colors:
                    raise ValueError("background index out of range")
                if background == 0:
                    raise ValueError("background index is 0")
        # GIF
        self.assign_buf_(0x47)
        self.assign_buf_(0x49)
        self.assign_buf_(0x46)
        # 89a
        self.assign_buf_(0x38)
        self.assign_buf_(0x39)
        self.assign_buf_(0x61)
        # Logical Screen iscriptor
        self.assign_buf_(self.width & 0xff)
        self.assign_buf_(self.width >> 8 & 0xff)
        self.assign_buf_(self.height & 0xff)
        self.assign_buf_(self.height >> 8 & 0xff)
        # Global color table flag
        if self.global_palette is None:
            self.assign_buf_(0 | gp_num_colors_pow2)
        else:
            self.assign_buf_(0x80 | gp_num_colors_pow2)
        # background color index
        self.assign_buf_(background)
        # pixel aspect ratio
        self.assign_buf_(0)
        # Fill global color table
        if self.global_palette is not None:
            self.fill_color_table(self.global_palette)
        else:
            print(" no global color table!")

        if self.loop_count is not None:
            if self.loop_count < 0 or self.loop_count > 65535:
                raise ValueError("invalid loop count")
            # extension code,label, and length
            self.assign_buf_(0x21)
            self.assign_buf_(0xff)
            self.assign_buf_(0x0b)
            # NetScape 2.0
            self.assign_buf_(0x4e)
            self.assign_buf_(0x45)
            self.assign_buf_(0x54)
            self.assign_buf_(0x53)
            self.assign_buf_(0x43)
            self.assign_buf_(0x41)
            self.assign_buf_(0x50)
            self.assign_buf_(0x45)
            self.assign_buf_(0x32)
            self.assign_buf_(0x2e)
            self.assign_buf_(0x30)
            # sub-block
            self.assign_buf_(0x03)
            self.assign_buf_(0x01)
            # print("current pos=" + str(self.ptr))
            self.assign_buf_(self.loop_count & 0xff)
            self.assign_buf_(self.loop_count >> 8 & 0xff)
            self.assign_buf_(0x00)


    def check_palette_and_num_colors(self, palette):
        num_colors = len( palette )
        if num_colors < 2 or num_colors > 256 or num_colors & (num_colors-1):
            print("warnning::palette colors number="+str(num_colors))
            # raise ValueError("Invalid color number in palette: must in [2,256] and is power of 2")
        return num_colors

    def add_frame(self, x, y, w, h, indexed_pixels, opts):
        print("\tGifWriter:: adding frame "+str(self.frame_count))
        if self.gif_ended:
            self.ptr -= 1
            self.gif_ended = False
        if opts is None:
            opts = {}
        if x < 0 or y < 0 or x > 65535 or y > 65535:
            raise ValueError("x y invalid")
        if w <= 0 or h <= 0 or w > 65535 or h > 65535:
            raise ValueError("w h invalid")
        if len(indexed_pixels) < w * h:
            raise ValueError("indexed_pixels is not enough for frame size")

        using_local_palette = True
        palette = opts.get('palette', None)
        if palette is None:
            palette = self.global_palette
            using_local_palette = False
        if using_local_palette == False:
            print("using_global palette")

        num_colors = self.check_palette_and_num_colors(palette)
        min_code_size = 0
        num_colors >>= 1
        while num_colors:
            min_code_size += 1
            num_colors >>= 1
        num_colors = 1 << min_code_size
        delay = opts.get('delay', self.delay)
        if delay is None:
            delay = 0
            print("delay not set")
        disposal = opts.get('disposal', self.disposal)
        if disposal is None:
            disposal = 0
        elif disposal < 0 or disposal > 3:
            raise ValueError("Disposal out of range")
        use_transparency = True
        transparent_index = opts.get('transparent', self.transparent_index)
        if transparent_index is None:
            use_transparency = False
            transparent_index = 0
        elif transparent_index < 0 or transparent_index >= num_colors:
            raise ValueError("Transparent color index invalid")
        # Graphics Control Extension
        if disposal != 0 or use_transparency or delay != 0:
            self.assign_buf_(0x21)
            self.assign_buf_(0xf9)
            self.assign_buf_(4 & 0xff)
            if use_transparency:
                t = 1
            else:
                t = 0
            self.assign_buf_(disposal << 2 | t)
            self.assign_buf_(delay & 0xff)
            self.assign_buf_(delay >> 8 & 0xff)
            self.assign_buf_(transparent_index)
            self.assign_buf_(0)   # block terminator
        # print("writing image seperator")
        # print("at pos:"+str(self.ptr))
        self.assign_buf_(0x2c)

        self.assign_buf_(x & 0xff)
        self.assign_buf_(x >> 8 & 0xff)

        self.assign_buf_(y & 0xff)
        self.assign_buf_(y >> 8 & 0xff)

        self.assign_buf_(w & 0xff)
        self.assign_buf_(w >> 8 & 0xff)

        self.assign_buf_(h & 0xff)
        self.assign_buf_(h >> 8 & 0xff)

        if using_local_palette:
            self.assign_buf_(0x80 | (min_code_size-1))
        else:
            self.assign_buf_(0)
        # Local Color Table
        if using_local_palette:
            self.fill_color_table(palette)
        
        if min_code_size < 2:
            min_code_size = 2
        self.lzw_encode(min_code_size, indexed_pixels)
        print("\tGifWriter:: frame "+str(self.frame_count)+" added")
        self.frame_count += 1

    def lzw_encode(self, min_code_size, index_stream):
        self.assign_buf_(min_code_size)
        self.cur_subblock = self.ptr
        self.ptr += 1

        self.clear_code = 1 << min_code_size
        self.code_mask = self.clear_code - 1
        self.eoi_code = self.clear_code + 1
        self.next_code = self.clear_code + 2
        self.cur_code_size = min_code_size + 1
        self.cur_shift = 0
        self.cur = 0

        ib_code = index_stream[0] & self.code_mask
        code_table = {}

        self.emit_code(self.clear_code)

        for i in range(1, len(index_stream)):
            k = index_stream[i] & self.code_mask
            cur_key = ib_code << 8 | k
            cur_code = code_table.get(cur_key, None)
            if cur_code is None:
                self.cur |= ib_code << self.cur_shift
                self.cur_shift += self.cur_code_size
                self.emit_bytes_to_buffer(8)

                if self.next_code == 4096:
                    self.emit_code(self.clear_code)
                    self.next_code = self.eoi_code + 1
                    self.cur_code_size = min_code_size + 1
                    code_table = {}
                else:
                    if self.next_code >= (1 << self.cur_code_size):
                        self.cur_code_size += 1
                    code_table[cur_key] = self.next_code
                    self.next_code += 1
                ib_code = k
            else:
                ib_code = cur_code
        self.emit_code(ib_code)
        self.emit_code(self.eoi_code)
        self.emit_bytes_to_buffer(1)

        if (self.cur_subblock+1) == self.ptr:
            self.buf_[self.cur_subblock] = 0
        else:
            self.buf_[self.cur_subblock] = self.ptr - self.cur_subblock -1
            self.assign_buf_(0)

    def emit_bytes_to_buffer(self, bit_block_size):
        while self.cur_shift >= bit_block_size:
            self.assign_buf_(self.cur & 0xff)
            self.cur >>= 8
            self.cur_shift -= 8
            if self.ptr == self.cur_subblock+256:
                self.buf_[self.cur_subblock] = 255
                self.cur_subblock = self.ptr
                self.ptr += 1

    def emit_code(self, c):
        self.cur |= c << self.cur_shift
        self.cur_shift += self.cur_code_size
        self.emit_bytes_to_buffer(8)

    def gif_end(self):
        if not self.gif_ended:
            self.assign_buf_(0x3b)
            self.gif_ended = True
        return self.ptr


if __name__ == '__main__':
    def gen_color_strip():
        buf = np.zeros(1024 * 1024)
        buf = buf.astype(np.uint8)
        p = [0x000000, 0xff0000]
        gf = GifWriter(buf, 256, 256, {'palette': p, 'background': 1})
        indices = [i for i in range(0, 256)]
        for i in range(0, 256):
            p = [(i << 16 | j << 8 | j) for j in range(0, 256)]
            gf.add_frame(0, i, 256, 1, indices, {'palette': p, 'disposal': 1})
        end = gf.gif_end()

        return buf[:end]


    with open("color_strip.gif", 'wb') as f:
        f.write(gen_color_strip())