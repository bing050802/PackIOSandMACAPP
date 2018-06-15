#!/bin/sh

#  pack.sh
#  PrivilegedTaskExample
#
#  Created by bing050802 on 2018/6/8.
#  Copyright © 2018年 Sveinbjorn Thordarson. All rights reserved.
SETTINGPATH=$1
PROJECTPATH=$2
Version=$3
exporpplist=./exportTest.plist
main(){
    cp -f $exporpplist $SETTINGPATH
    cp -f $PROJECTPATH/Cloudoc2/YHZConfig.plist $SETTINGPATH
    cp -f $PROJECTPATH/Cloudoc2/Info.plist $SETTINGPATH
#    local version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${PROJECTPATH}/Cloudoc2/Info.plist")
    /usr/libexec/PlistBuddy -c "Set :YHZConfig_Version ${Version}" "${SETTINGPATH}/YHZConfig.plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${Version}" "${SETTINGPATH}/Info.plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${Version}" "${SETTINGPATH}/Info.plist"
    cp -f "${SETTINGPATH}/Info.plist" "$PROJECTPATH/Cloudoc2/Info.plist"
    ./productIPA.sh $SETTINGPATH $PROJECTPATH "${SETTINGPATH}/exportTest.plist"

}
main
