import cv2
import time
import datetime


class V2P(object):
    def __init__(self, filename, cut=False, st='00:00:00', et="00:00:00", rate=4):
        super(V2P, self).__init__()
        self.filename = filename
        self.cut = cut
        self.start = self.format_time_to_seconds(st)
        self.end = self.format_time_to_seconds(et)
        self.rate = rate
        self.frames = []
        self.width = -1
        self.height = -1
        # print(cv2.__version__)

    def fetch(self):
        vidcap = cv2.VideoCapture(self.filename)
        # vidcap.set(0, self.start )
        (major_ver, minor_ver, subminor_ver) = (cv2.__version__).split('.')
        if int(major_ver) < 3:
            fps = vidcap.get(cv2.cv.CV_CAP_PROP_FPS)
            self.width = vidcap.get(cv2.cv.CV_CAP_PROP_FRAME_WIDTH)
            self.height = vidcap.get(cv2.cv.CV_CAP_PROP_FRAME_HEIGHT)
        else:
            fps = vidcap.get(cv2.CAP_PROP_FPS)
            self.width = vidcap.get(cv2.CAP_PROP_FRAME_WIDTH)
            self.height = vidcap.get(cv2.CAP_PROP_FRAME_HEIGHT)
        success, image = vidcap.read()
        count = 0
        imgCount = 0
        start_frame = self.start * fps
        end_frame = self.end * fps
        success = True
        while success:
            success, image = vidcap.read()
            if self.cut:
                if count >= start_frame and count <= end_frame:
                    if count % self.rate == 0:
                        self.frames.append(image.astype(int))
                        imgCount += 1
            else:
                if count % self.rate == 0:
                    self.frames.append(image.astype(int))
                    imgCount += 1
            count += 1

    def write_frame(self, imgType='bmp'):
        count = 0
        for x in self.frames:
            cv2.imwrite("./temp/frame%d.%s"%(count, imgType), x)
            count += 1
        print("Frames saved at temp directories as "+imgType+" format.")

    def format_time_to_seconds(self, timeStr):
        """change H:M:S format time to seconds"""
        x = time.strptime(timeStr, '%H:%M:%S')
        return datetime.timedelta(hours=x.tm_hour, minutes=x.tm_min, seconds=x.tm_sec).total_seconds()


if __name__ == '__main__':
    x = V2P("input.mp4", "00:01:30", "00:01:40")
    x.fetch()
    print(x.width)
    print(x.height)
    x.write_frame('jpg')
