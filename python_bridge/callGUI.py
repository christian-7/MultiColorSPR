import matlab.engine
eng = matlab.engine.start_matlab()

eng.basicGUI   #sending input to the function

input("Press Enter to continue...")

print('Done')