from video2gif import Vid2Gif

v2g = Vid2Gif("input.mp4", cut=True,st="00:02:00", et="00:02:10")
v2g.set_config('delay',10)

v2g.write_gif(gif_file='from_frame.gif',direct_from_memory=True)