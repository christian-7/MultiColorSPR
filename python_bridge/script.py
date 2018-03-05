import matlab.engine
eng = matlab.engine.start_matlab()
eng.basicsignals(nargout=0)
eng.plotsin(nargout=0)