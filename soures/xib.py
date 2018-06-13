#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import print_function
import os
import sys
import re



def main():
    print(sys.argv[2])
    print("~~~~~~~~~~~~~~~~~~~~")
    fileName=sys.argv[1]
    icon_name=sys.argv[2]+".png"
    slogan_name=sys.argv[3]+".png"
    f= open(fileName, "r")
    content=f.read()
    f.close()
    print(content)
  
    str=re.sub(r'icon_logo_2_cloudoc_2_en(\w)*.png',icon_name,content)
    print("~~~~~~~~~~~~~~~~~~~~~")
    print(str)
    str2=re.sub("slogan_1_en(\w)*.png",slogan_name,str)
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
