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

    find $imageDistinationPath -name $pattern -print -exec cp -f $imagePath '{}' \;

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

    getNameAndCopy "$imagePath/$logo_en2" $enlprojPath "icon_logo_2_cloudoc_2_en*@2x.png"
    getNameAndCopy "$imagePath/$logo_en3" $enlprojPath "icon_logo_2_cloudoc_2_en*@3x.png"
    getNameAndCopy "$imagePath/$slogan2" $enlprojPath "slogan*@2x.png"
    getNameAndCopy "$imagePath/$slogan3" $enlprojPath "slogan*@3x.png"


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
        dpath="$d""/icon_logo_2_cloudoc_2@"$i"x.png"
        echo $dpath
        spath="${imagePath}/logo_en@${i}x.png"
        cp -f $spath $enlprojPath
        echo $spath
        echo $enlprojPath
        echo $i
done

}

replaceInfoplist(){
    local infoplist=$1/Info.plist
    local projectplist=$2/Cloudoc2/Info.plist
    cp -f $infoplist $projectplist
    echo sucesss? $?
}
replaceConfigPlist(){
    local infoplist=$1/YHZConfig.plist
    local projectplist=$2/Cloudoc2/YHZConfig.plist
    cp -f $infoplist $projectplist
    echo sucesss? $?
}

main(){

    cp -f $ContentsjsonPath $SETTINGPATH/AppIcon_2.appiconset


    copyappiconset $SETTINGPATH $PROJECTPATH
    copyLogo $SETTINGPATH $PROJECTPATH
    replaceInfoplist $SETTINGPATH $PROJECTPATH
    replaceConfigPlist $SETTINGPATH $PROJECTPATH

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
