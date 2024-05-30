from struct import unpack
from matplotlib import projections
import numpy as np
import matplotlib.pyplot as plt

path = "Result/"
FFDH = "FFDHPerform.txt"
NFDH = "NFDHPerform.txt"
BFDH = "BFDHPerform.txt"
BL = "BLPerform.txt"
RF = "RFPerform.txt"

FFDH_color = "#8e0984"
NFDH_color = "#0469bb"
BFDH_color = "#f49904"
BL_color = "#009b45"
RF_color = "#e0475b"

''' --------       Time Compare          -------- '''
time_fig = plt.figure() # new a figure

''' Compare plot '''
ax_mix = time_fig.add_subplot(projection = '3d') # new a sub plot

# scatter FFDH
width_FFDH, n_FFDH, time_taken_FFDH = np.loadtxt(path + FFDH, delimiter = " ", usecols=(0, 1, 2), unpack = True)
ax_mix.scatter3D(width_FFDH, n_FFDH, time_taken_FFDH, color = FFDH_color, label = 'FFDH')

# scatter NFDH
width_NFDH, n_NFDH, time_taken_NFDH = np.loadtxt(path + NFDH, delimiter = " ", usecols=(0, 1, 2), unpack = True)
ax_mix.scatter3D(width_NFDH, n_NFDH, time_taken_NFDH, color = NFDH_color, label = 'NFDH')

# scatter BFDH
width_BFDH, n_BFDH, time_taken_BFDH = np.loadtxt(path + BFDH, delimiter = " ", usecols=(0, 1, 2), unpack = True)
ax_mix.scatter3D(width_BFDH, n_BFDH, time_taken_BFDH, color = BFDH_color, label = 'BFDH')

# scatter BL
width_BL, n_BL, time_taken_BL = np.loadtxt(path + BL, delimiter = " ", usecols=(0, 1, 2), unpack = True)
ax_mix.scatter3D(width_BL, n_BL, time_taken_BL, color = BL_color, label='BL')

# scatter RF
width_RF, n_RF, time_taken_RF = np.loadtxt(path + RF, delimiter = " ", usecols=(0, 1, 2), unpack = True)
ax_mix.scatter3D(width_RF, n_RF, time_taken_RF, color = RF_color, label='RF')

ax_mix.legend()
ax_mix.set_xlabel('width')
ax_mix.set_ylabel('n')
ax_mix.set_zlabel('time/s')
ax_mix.set_title('Time Compare')

time_fig_without_BL = plt.figure() # new a figure
''' Compare plot without BL'''
ax_mix_4 = time_fig_without_BL.add_subplot(projection = '3d') # new a sub plot

# scatter FFDH
ax_mix_4.scatter3D(width_FFDH, n_FFDH, time_taken_FFDH, color = FFDH_color, label = 'FFDH')
# scatter NFDH
ax_mix_4.scatter3D(width_NFDH, n_NFDH, time_taken_NFDH, color = NFDH_color, label = 'NFDH')
# scatter BFDH
ax_mix_4.scatter3D(width_BFDH, n_BFDH, time_taken_BFDH, color = BFDH_color, label = 'BFDH')
# scatter RF
ax_mix_4.scatter3D(width_RF, n_RF, time_taken_RF, color = RF_color, label = 'RF')

ax_mix_4.legend()
ax_mix_4.set_xlabel('width')
ax_mix_4.set_ylabel('n')
ax_mix_4.set_zlabel('time/s')
ax_mix_4.set_title('Time Compare Without BL')

time_split_fig = plt.figure() # new a figure

''' FFDH plot '''
ax_FFDH = time_split_fig.add_subplot(221, projection = '3d')
ax_FFDH.scatter3D(width_FFDH, n_FFDH, time_taken_FFDH, color = FFDH_color)
ax_FFDH.set_xlabel('width')
ax_FFDH.set_ylabel('n')
ax_FFDH.set_zlabel('time/s')
ax_FFDH.set_title('FFDH')

''' NFDH plot '''
ax_NFDH = time_split_fig.add_subplot(222, projection = '3d')
ax_NFDH.scatter3D(width_NFDH, n_NFDH, time_taken_NFDH, color = NFDH_color)
ax_NFDH.set_xlabel('width')
ax_NFDH.set_ylabel('n')
ax_NFDH.set_zlabel('time/s')
ax_NFDH.set_title('NFDH')

''' BFDH plot '''
ax_BFDH = time_split_fig.add_subplot(234, projection = '3d')
ax_BFDH.scatter3D(width_BFDH, n_BFDH, time_taken_BFDH, color = BFDH_color)
ax_BFDH.set_xlabel('width')
ax_BFDH.set_ylabel('n')
ax_BFDH.set_zlabel('time/s')
ax_BFDH.set_title('BFDH')

''' BL plot '''
ax_BL = time_split_fig.add_subplot(235, projection = '3d')
ax_BL.scatter3D(width_BL, n_BL, time_taken_BL, color = BL_color)
ax_BL.set_xlabel('width')
ax_BL.set_ylabel('n')
ax_BL.set_zlabel('time/s')
ax_BL.set_title('BL')

''' RF plot '''
ax_RF = time_split_fig.add_subplot(236, projection = '3d')
ax_RF.scatter3D(width_RF, n_RF, time_taken_RF, color = RF_color)
ax_RF.set_xlabel('width')
ax_RF.set_ylabel('n')
ax_RF.set_zlabel('time/s')
ax_RF.set_title('RF')


''' --------       Result Compare          -------- '''
result_fig = plt.figure()

''' Compare plot '''
ax_result = result_fig.add_subplot(projection = '3d')

# scatter FFDH
width_FFDH, n_FFDH, result_FFDH = np.loadtxt(path + FFDH, delimiter = " ", usecols=(0, 1, 3), unpack = True)
ax_result.scatter3D(width_FFDH, n_FFDH, result_FFDH, color = FFDH_color, label = 'FFDH')

# scatter NFDH
width_NFDH, n_NFDH, result_NFDH = np.loadtxt(path + NFDH, delimiter = " ", usecols=(0, 1, 3), unpack = True)
ax_result.scatter3D(width_NFDH, n_NFDH, result_NFDH, color = NFDH_color, label = 'NFDH')

# scatter BFDH
width_BFDH, n_BFDH, result_BFDH = np.loadtxt(path + BFDH, delimiter = " ", usecols=(0, 1, 3), unpack = True)
ax_result.scatter3D(width_BFDH, n_BFDH, result_BFDH, color = BFDH_color, label = 'BFDH')

# scatter BL
width_BL, n_BL, result_BL = np.loadtxt(path + BL, delimiter = " ", usecols=(0, 1, 3), unpack = True)
ax_result.scatter3D(width_BL, n_BL, result_BL, color = BL_color, label='BL')

# scatter RF
width_RF, n_RF, result_RF = np.loadtxt(path + RF, delimiter = " ", usecols=(0, 1, 3), unpack = True)
ax_result.scatter3D(width_RF, n_RF, result_RF, color = RF_color, label='RF')

ax_result.legend()
ax_result.set_xlabel('width')
ax_result.set_ylabel('n')
ax_result.set_zlabel('height')
ax_result.set_title('Result Compare')

# show the figure
plt.show()
