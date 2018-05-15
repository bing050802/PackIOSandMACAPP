#!/bin/bash
SETTINGPATH=$1
PROJECTPATH=$2
contentPath=$3
contentjsonPath=$4
exporpplist=$5
main(){
    ./read.sh $contentPath  $SETTINGPATH/cloud_ico.png
    ./copySource.sh $SETTINGPATH $PROJECTPATH $contentjsonPath
    ./productIPA.sh $SETTINGPATH $PROJECTPATH $exporpplist
}

main

