#!/bin/bash
SETTINGPATH=$1
PROJECTPATH=$2
contentPath=$3
contentjsonPath=$4
main(){
    ./read.sh $contentPath  $SETTINGPATH/cloud_ico.png
    ./copySource.sh $SETTINGPATH $PROJECTPATH $contentjsonPath
}

main

