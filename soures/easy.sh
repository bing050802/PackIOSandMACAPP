#!/bin/sh

#  easy.sh
#  PrivilegedTaskExample
#
#  Created by bing050802 on 2018/5/16.
#  Copyright © 2018年 Sveinbjorn Thordarson. All rights reserved.
SETTINGPATH=$1
PROJECTPATH=$2
contentPath=./content.txt
contentjsonPath=./Contents.json
exporpplist=./exportTest.plist
main(){
    ./read.sh $contentPath  $SETTINGPATH/cloud_ico.png
    ./copySource.sh $SETTINGPATH $PROJECTPATH $contentjsonPath
   ./productIPA.sh $SETTINGPATH $PROJECTPATH $exporpplist

}
main
