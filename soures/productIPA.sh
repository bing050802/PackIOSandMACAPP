#!/bin/sh

#  productIPA.sh
#  PrivilegedTaskExample
#
#  Created by bing050802 on 2018/5/15.
#  Copyright © 2018年 Sveinbjorn Thordarson. All rights reserved.

SETTINGPATH=$1
PROJECTPATH=$2


development_mode=Release



xcodebuild \
clean -configuration ${development_mode}

xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive

xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath}
