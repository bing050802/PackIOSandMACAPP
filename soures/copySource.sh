#!/bin/bash
SETTINGPATH=$1
PROJECTPATH=$2
ContentsjsonPath=$3

readonly logo_en2="logo_en@2x.png"
readonly logo_en3="logo_en@3x.png"
readonly logo2="logo@2x.png"
readonly logo3="logo@3x.png"
readonly slogan2="slogan@2x.png"
readonly slogan3="slogan@3x.png"

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
    imagePath=$sourcePath/AppIcon_2.appiconset
    imageDistinationPath=$PROJECTPATH/Cloudoc2/NEWYHZ.xcassets
    app_icon_dpath=$distinationPath'/Cloudoc2/NEWYHZ.xcassets/AppIcon_2.appiconset'

    rm -rf $app_icon_dpath
    cp -rf $imagePath $imageDistinationPath

}

getNameAndCopy(){
   local imagePath=$1
    local imageDistinationPath=$2
   local pattern=$3
    local newName=$4

    name=$(find $imageDistinationPath -name $pattern -print)
    rm -f imageDistinationPath/name
    cp -f $imagePath $imageDistinationPath/$newName

}

copyLogo(){

    local imagePath=$1
    local distinationPath=$2
    local enlprojPath=$distinationPath/Cloudoc2/en.lproj
    local baseDiretory=$distinationPath'/Cloudoc2/Base.lproj'
    local hansDiretory=$distinationPath'/Cloudoc2/zh-Hans.lproj'

    logo_en=$(find $imagePath -name $logo_en2 -print)
    echo logo_en$logo_en
    if [  x"$logo_en"="x" ];then
        cp -f $imagePath/$logo2 $imagePath/$logo_en2
    fi

    logo_en1=$(find $imagePath -name $logo_en3 -print)
    echo logo_en1$logo_en1
    if [ -z $logo_en1 ];then
        cp -f $imagePath/$logo3 $imagePath/$logo_en3
    fi

    local today=`date +%Y%m%d%H%M%S`

    icon_logo=icon_logo_2_cloudoc_2_en_${today}
    slogan=slogan_1_en_${today}
    python xib.py $imagePath/YHZLaunchScreen.xib $icon_logo $slogan
    cp -f $imagePath/YHZLaunchScreen2.xib $distinationPath/Cloudoc2/YHZLaunchScreen.xib
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!"
    find $enlprojPath -name "icon_logo_2_cloudoc_2_en*.png" -print -exec rm -f {} \;
    find $enlprojPath -name "slogan*.png" -print -exec rm -f {} \;

    for i in {2,3};do
        spath="${imagePath}/logo@${i}x.png"
        cp -f $spath "${enlprojPath}/${icon_logo}@${i}x.png"
        sloganpath="${imagePath}/slogan@${i}x.png"
        cp -f $sloganpath $enlprojPath//${slogan}@${i}x.png
        echo $spath
        echo $sloganpath
        echo $i
    done






    for d in {$baseDiretory,$hansDiretory};do
        for i in {2,3};do
            dpath="$d""/icon_logo_2_cloudoc_2@"$i"x.png"
            echo $dpath
            spath="${imagePath}/logo@${i}x.png"
            cp -f $spath $dpath
            echo $spath
            echo $dpath
            echo $i
        done
    done


    for i in {2,3};do
        dpath="$enlprojPath/icon_logo_2_cloudoc_2@${i}x.png"
        echo $dpath
        spath="${imagePath}/logo_en@${i}x.png"
        cp -f $spath $dpath
        echo $spath
        echo $enlprojPath
        echo $i
    done

}

replaceInfoplist(){
    local infoplist=$1/Info.plist
    local projectplist=$2/Cloudoc2/Info.plist
    cp -f $infoplist $projectplist
    echo $projectplist
    echo replaceInfoplist sucesss? $?
}
replaceConfigPlist(){
    local infoplist=$1/YHZConfig.plist
    local projectplist=$2/Cloudoc2/YHZConfig.plist
    cp -f $infoplist $projectplist
    echo $projectplist
    echo sucesss? $?
}

copyFiles(){
    local settingPath
    local projectPath


}
replaceAPPName(){
    local settingPath=$1
    local projectPath=$2

    Config_chinese=$(/usr/libexec/PlistBuddy -c "Print YHZConfig_Chinese" "${settingPath}/YHZConfig.plist")
    echo $Config_chinese
    infoPlist_dpath=$projectPath'/Cloudoc2/zh-Hans.lproj/InfoPlist.strings'
    : > $infoPlist_dpath
    echo "$infoPlist_dpath cleaned up."
    echo "CFBundleDisplayName =\"${Config_chinese}\";"  > $infoPlist_dpath

    Config_English=$(/usr/libexec/PlistBuddy -c "Print YHZConfig_English" "${settingPath}/YHZConfig.plist")

    echo "修改英文appName"
    infoPlist_dpath=$projectPath'/Cloudoc2/en.lproj/InfoPlist.strings'
    : > $infoPlist_dpath
    echo "$infoPlist_dpath cleaned up."
    echo "CFBundleDisplayName =\"$Config_English\";"  > $infoPlist_dpath

}


main(){

    cp -f $ContentsjsonPath $SETTINGPATH/AppIcon_2.appiconset
    cp -f $PROJECTPATH/Cloudoc2/YHZLaunchScreen.xib $SETTINGPATH


    copyappiconset $SETTINGPATH $PROJECTPATH
    copyLogo $SETTINGPATH $PROJECTPATH
    replaceInfoplist $SETTINGPATH $PROJECTPATH
    replaceConfigPlist $SETTINGPATH $PROJECTPATH
    replaceAPPName $SETTINGPATH $PROJECTPATH
#    imagePath=$SETTINGPATH/AppIcon_2.appiconset
#    imageDistinationPath=$PROJECTPATH/Cloudoc2/NEWYHZ.xcassets
#
#    app_icon_dpath=$PROJECTPATH'/Cloudoc2/NEWYHZ.xcassets/AppIcon_2.appiconset'
#    chmod 777 $app_icon_dpath
#    rm -rf $app_icon_dpath
#    cp -rf $imagePath $imageDistinationPath




#    copyIconsToProject $imagePath $app_icon_dpath

}

main
