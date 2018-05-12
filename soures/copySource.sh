#!/bin/bash
SETTINGPATH=$1
PROJECTPATH=$2
ContentsjsonPath=$3

copyIconsToProject(){
    local sourcePath=$1
    local distinationPath=$2
    echo $sourcePath
    echo $distinationPath
    ls $sourcePath
    find $sourcePath -name '*.png' -print -exec cp -f '{}' $distinationPath \;

}

copyappiconset(){
    local sourcePath=$1
    local distinationPath=$2
    copy -f $sourcePath $distinationPath
}


main(){

    cp -f $ContentsjsonPath $SETTINGPATH/AppIcon_2.appiconset

    imagePath=$SETTINGPATH/AppIcon_2.appiconset
    imageDistinationPath=$PROJECTPATH/Cloudoc2/NEWYHZ.xcassets

    app_icon_dpath=$PROJECTPATH'/Cloudoc2/NEWYHZ.xcassets/AppIcon_2.appiconset/'
    chmod 777 $app_icon_dpath
    rm -rf $app_icon_dpath
    cp -rf $imagePath $imageDistinationPath
}

main
