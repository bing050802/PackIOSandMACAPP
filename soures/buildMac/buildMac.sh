#!/bin/sh

#  buildMac.sh
#  PrivilegedTaskExample
#
#  Created by bing050802 on 2018/6/7.
#  Copyright © 2018年 Sveinbjorn Thordarson. All rights reserved.

#BUILDDIR=$2

ifndef BUILDDIR
BUILDDIR := $(shell mktemp -d "$(TMPDIR)/Sparkle.XXXXXX")
endif
build=$(dirname $0)
#用App2Dmg打包时候在临时目录生成了 dmg文件，生成同名dmg文件会出错，所以先删除
rm -rf /Users/dddddddddd/Library/Application\ Support/App2Dmg/.temp
echo $?

infoPlistPath=${build}/CloudocForMac/Supporting\ Files/Info.plist
app_name="云盒子"
app_version=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "$infoPlistPath")

echo '///-----------'
echo '/// 正在编译工程:'
echo '///-----------'
rm -rf "${build}/build/Release"
echo $?
xcodebuild clean
xcodebuild -configuration Release -derivedDataPath "$(BUILDDIR)" build
#open  "${build}/build/Release"
mv -f "${build}/build/Release/CloudocForMac.app" "${build}/build/Release/云盒子.app"

echo '///-----------'
echo '/// 正在打包dmg'
echo '///-----------'

dmgPath="${build}/createdmg"
appPath="${dmgPath}/app"

test -d $appPath &&  rm -rf $appPath
echo $?
mkdir $appPath
mv -f "${build}/build/Release/云盒子.app"  "${appPath}/云盒子.app"



#已经切换目录了
#cd ${dmgPath}
find ${build} -name "*.dmg" -print -exec rm -rf {} \;
find $dmgPath -name "*.dmg" -print -exec rm -rf {} \;
echo $?
app_dmg_name="${app_name}(${app_version}).dmg"
sh "$dmgPath/create-dmg" --background "${dmgPath}/support/Install_bac.png" --window-size 609 323 --window-pos 400 400 --icon-size 96 --icon "云盒子" 174 138 --app-drop-link 430 138 --hide-extension "云盒子.app"  "${app_dmg_name}" "${appPath}/云盒子.app"


open "${build}"
