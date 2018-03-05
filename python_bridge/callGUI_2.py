from pymatbridge import Matlab
mlab = Matlab(matlab='/Applications/MATLAB_R2016a.app/bin/matlab')
mlab.start()
res = mlab.run('basicGUI.m')
