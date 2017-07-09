import os
import win32com.client as win32
import easygui

path = easygui.fileopenbox()
aspen = win32.Dispatch('Apwn.Document')
# aspen.InitFromArchive2(os.path.abspath('data\FLASH.bkp'))
aspen.InitFromArchive2(path)

def print_elements(obj,level):
    text_file = open("Output2.txt","a")

    if hasattr(obj,'Elements'):
        s=" "
        inde='    '*level
        seq="{0}{1}{2}{3}{4}\n".format(inde,level,'.',s, obj.Name)
        text_file.write(seq)
        for o in obj.Elements:
            print_elements(o,level+1)
    else:
        s=" "
        inde='    '*(level+1)
        seq="{0}{1}{2}{3}{4}{5}\n".format(inde,obj.Name,s,'=',s,str(obj.Value))
        text_file.write(seq)
    text_file.close()

print_elements(aspen.Tree,0)

aspen.close()