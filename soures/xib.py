#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function
import os
import sys
import re
import base64


def main():
    print(sys.argv[2])
    print("~~~~~~~~~~~~~~~~~~~~")
    fileName=sys.argv[1]
    icon_name=sys.argv[2]+".png"
    slogan_name=sys.argv[3]+".png"
    rightStr=sys.argv[4]
    f= open(fileName, "r")
    content=f.read()
    f.close()
    print(rightStr,content)
  
    str=re.sub(r'icon_logo_2_cloudoc_2_en(\w)*.png',icon_name,content)
    print("~~~~~~~~~~~~~~~~~~~~~")
    print(str)
    str2=re.sub("slogan_1_en(\w)*.png",slogan_name,str)
    
    replaceRight="<string key=\"text\" base64-UTF8=\"YES\">\n"+base64.b64encode(rightStr)+"\n</string>"
    print(rightStr,replaceRight)
    str2=re.sub("<string key=\"text\" base64-UTF8=\"YES\">\n(\w)*\n<\/string>",replaceRight,str2);
    
    dirname=os.path.dirname(fileName)
    fileName2=dirname+"/YHZLaunchScreen2.xib"
    print(fileName2)
    fh=open(fileName2,'w')
    print(slogan_name)
    print("~~~~~~~~~~~~~~~~~~~~~")
    print(str2)
    fh.write(str2)
    fh.close()


if __name__ == "__main__":
    main()
