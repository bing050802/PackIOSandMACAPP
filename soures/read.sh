#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGS="$@"

readonly IMAGECONTENTS=$1
IMAGEFILE=$2
OUTPATH=$3

usage() {

  echo  -e "\033[31m usage: $PROGNAME ./content.text ./pic.png [out] \033[0m"
  echo  -e "\033[31m    content.txt \033[0m"
  echo  -e "\033[31m       size:fileName \033[0m"
  echo  -e "\033[31m           40:icon40*40.png \033[0m"
  echo  -e "\033[31m           50:icon50*50.png \033[0m"
  echo  -e "\033[31m     pic.png"  "an image in 1024x1024 pixels \033[0m"
  echo  -e "\033[31m        .jpg \033[0m"
  echo  -e "\033[31m     [out]  \033[0m"
  echo  -e "\033[31m ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \033[0m"


  echo -e "\033[31m If [out] is not specified, it is output to the address directory of the original image ./images, and the specified output directory is output to the directory. \033[0m"
}

imageWithSize(){
    local   size=$1
    local   inputFile=$2
    local   fileName=$3
    local   outputPath=$4
    local   imagePath=$outputPath/$filename

    sips -Z $size $inputFile --out $imagePath;
    if [ $? -eq 0 ];then
        echo "create image size $size $filename sucess"
    else
        echo "create image size $size $filename failed"

    fi

}

imageWithContents(){
    local imageFile=$1
    local outputPath=$2
    local inputFile=$3

    while IFS=: read -r size filename; do
        echo $size $filename
        imageWithSize $size $imageFile $filename $outputPath
    done < $inputFile
}

ouputPath(){
    local outputPath=$2
    local imagePath=$1
    local imageOuputPath
    if [ -n "$outputPath" ];then
        imageOuputPath=$outputPath
    else
        imageOuputPath="$imagePath/AppIcon_2.appiconset"
        mkdir $imageOuputPath

    fi
     echo $imageOuputPath
}
createImages(){
    local imageFile=$1
    local inputFile=$2
    local outputPath=$3

    local imagePath=$(dirname $imageFile)
    local path=$(ouputPath $imagePath $outputPath)
    echo 输出目录:$path
    chmod 777 $path
    echo createImagesinputFile:$inputFile
    imageWithContents $imageFile $path $inputFile
}

main(){
    usage
    createImages $IMAGEFILE $IMAGECONTENTS $OUTPATH
}

main
