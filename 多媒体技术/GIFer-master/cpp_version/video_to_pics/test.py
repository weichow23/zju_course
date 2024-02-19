from ImgFetcher import IF

x = IF("input.mp4","00:01:30","00:02:00")

x.fetch()

x.write_frame('jpg')