import cv2
import time
import datetime

class IF(object):
	"""Image Fetch from a video"""
	def __init__(self, filename, st='00:00:00', et="00:00:00", rate = 10 ):
		super(IF, self).__init__()
		self.filename = filename
		self.start = self.format_time_to_seconds(st)
		self.end = self.format_time_to_seconds(et)
		self.rate = rate
		self.frames = []
		print(cv2.__version__)
	
	def fetch(self):
		vidcap = cv2.VideoCapture(self.filename)
		# vidcap.set(0, self.start )
		(major_ver, minor_ver, subminor_ver) = (cv2.__version__).split('.')
		if int( major_ver )< 3:
			fps = vidcap.get(cv2.cv.CV_CAP_PROP_FPS)
		else:
			fps = vidcap.get(cv2.CAP_PROP_FPS)
		success,image = vidcap.read()
		count = 0
		imgCount = 0
		start_frame = self.start * fps
		end_frame = self.end * fps
		success = True
		while success:
			success,image = vidcap.read()
			if count >= start_frame and count <= end_frame:
				if count % self.rate == 0:
					# cv2.imwrite("frame%d.bmp" % imgCount, image )
					self.frames.append(image)
					imgCount += 1
			count += 1

	def write_frame(self, imgType='bmp'):
		count = 0
		for x in self.frames:
			cv2.imwrite("frame%d.%s" % (count,imgType), x )

	def format_time_to_seconds(self, timeStr ):
		"""change H:M:S format time to seconds"""
		x = time.strptime( timeStr,'%H:%M:%S')
		return datetime.timedelta(hours=x.tm_hour,minutes=x.tm_min,seconds=x.tm_sec).total_seconds()