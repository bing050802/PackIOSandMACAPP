#!/bin/sh

#  productIPA.sh
#  PrivilegedTaskExample
#
#  Created by bing050802 on 2018/5/15.
#  Copyright © 2018年 Sveinbjorn Thordarson. All rights reserved.

SETTINGPATH=$1
PROJECTPATH=$2
EXPORTPLIST=$3

DEVELOP_MODE=Release
PROJECT_NAME=Cloudoc2
SCHEME_NAME=Cloudoc2

clean(){
    xcodebuild \
    clean -configuration ${development_mode}
}

buildArchive(){
    local project_path=$1
    local project_name=$2
    local scheme_name=$3
    local development_mode=$4
    local archivePath=$5
    local path=$(dirname $archivePath)
    local logPath="${path}/compile_commands.json"

    echo '///-----------'
    echo '/// 正在编译工程:'${development_mode}
    echo '///-----------'
    clean
    xcodebuild \
    archive -project ${project_path}/${project_name}.xcodeproj \
    -scheme ${scheme_name} \
    -configuration ${development_mode} \
    -archivePath $archivePath
#\
#    build | xcpretty -r json-compilation-database -o logPath

    echo '///--------'
    echo '/// 编译完成'
    echo '///--------'
    echo ''

}

archiveToIPA(){
    local archivePath=$1
    local development_mode=$2
    local exportIpaPath=$3
    local exportIpaPathPlist=$4
    local name=$5

    xcodebuild -exportArchive -archivePath $archivePath \
    -exportPath $exportIpaPath
    xcodebuild -exportArchive -archivePath ${archivePath} \
    -configuration ${development_mode} \
    -exportPath ${exportIpaPath} \
    -exportOptionsPlist ${exportIpaPathPlist}


    if [ -e $exportIpaPath ]; then
        echo '///----------'
        echo '/// ipa包已导出'
        echo '///----------'
        open $exportIpaPath
        mv $exportIpaPath/ClouDocIphone2.ipa $exportIpaPath/${name}
    else
        echo '///-------------'
        echo '/// ipa包导出失败 '
        echo '///-------------'
fi

}

main(){
    echo archivePath
    local version=$(/usr/libexec/PlistBuddy -c "Print YHZConfig_Version" "${SETTINGPATH}/YHZConfig.plist")
    local name=$(/usr/libexec/PlistBuddy -c "Print YHZConfig_English" "${SETTINGPATH}/YHZConfig.plist")

    local today=`date +%Y%m%d%H%M%S`
    local archiveName="${name}(${version})"
    local archivePath="${SETTINGPATH}/archivePath/archive${today}/${archiveName}.xcarchive"

    local exportIpaPath=${SETTINGPATH}/archivePath/ipa${today}
    local exportIpaPathName=${archiveName}.ipa

    buildArchive $PROJECTPATH $PROJECT_NAME $SCHEME_NAME $DEVELOP_MODE $archivePath
    archiveToIPA $archivePath $DEVELOP_MODE $exportIpaPath $EXPORTPLIST $exportIpaPathName
}

main





