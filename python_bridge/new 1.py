# https://www.python-course.eu/tkinter_dialogs.php
# File open dialog

from Tkinter import *
from tkFileDialog   import askopenfilename      

def callback():
    name= askopenfilename() 
    print name
    
errmsg = 'Error!'
Button(text='File Open', command=callback).pack(fill=X)
mainloop()

# http://zetcode.com/gui/tkinter/layout/
# Load and display an image

from PIL import Image, ImageTk
from tkinter import Tk, BOTH
from tkinter.ttk import Frame, Label, Style

class Example(Frame):
  
    def __init__(self):
        super().__init__()   
         
        self.initUI()

        
    def initUI(self):
      
        self.master.title("Absolute positioning")
        self.pack(fill=BOTH, expand=1)
        
        Style().configure("TFrame", background="#333")
        
        bard = Image.open("bardejov.jpg")
        bardejov = ImageTk.PhotoImage(bard)
        label1 = Label(self, image=bardejov)
        label1.image = bardejov
        label1.place(x=20, y=20)
        
        rot = Image.open("rotunda.jpg")
        rotunda = ImageTk.PhotoImage(rot)
        label2 = Label(self, image=rotunda)
        label2.image = rotunda
        label2.place(x=40, y=160)        
        
        minc = Image.open("mincol.jpg")
        mincol = ImageTk.PhotoImage(minc)
        label3 = Label(self, image=mincol)
        label3.image = mincol
        label3.place(x=170, y=50)        
              

def main():
  
    root = Tk()
    root.geometry("300x280+300+300")
    app = Example()
    root.mainloop()  


if __name__ == '__main__':
    main()  

	
	
# http://sebsauvage.net/python/gui/#add_button

