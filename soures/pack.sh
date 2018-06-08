#!/bin/sh

#  pack.sh
#  PrivilegedTaskExample
#
#  Created by bing050802 on 2018/6/8.
#  Copyright © 2018年 Sveinbjorn Thordarson. All rights reserved.
SETTINGPATH=$1
PROJECTPATH=$2
exporpplist=./exportTest.plist
main(){
    cp -f $exporpplist $SETTINGPATH
    ./productIPA.sh $SETTINGPATH $PROJECTPATH $SETTINGPATH/exportTest.plist

}
main
