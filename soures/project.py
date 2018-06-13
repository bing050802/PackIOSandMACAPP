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
    icon_name=sys.argv[2]
    slogan_name=sys.argv[3]
   
    f= open(fileName, "r")
    content=f.read()
    f.close()
    print(content)
    
    str=re.sub(r'icon_logo_2_cloudoc_2_en(\w)*@2x.png',icon_name+"@2x.png",content)
    str=re.sub(r'icon_logo_2_cloudoc_2_en(\w)*@3x.png',icon_name+"@3x.png",str)
    print("~~~~~~~~~~~~~~~~~~~~~")
    print(str)
    str=re.sub("slogan_1_en(\w)*@2x.png",slogan_name+"@2x.png",str)
    str=re.sub("slogan_1_en(\w)*@3x.png",slogan_name+"@3x.png",str)
  
    
    dirname=os.path.dirname(fileName)
    fileName2=dirname+"/project2.pbxproj"
    print(fileName2)
    fh=open(fileName2,'w')
    print(slogan_name)
    print("~~~~~~~~~~~~~~~~~~~~~")
    print(str)
    fh.write(str)
    fh.close()


if __name__ == "__main__":
    main()

