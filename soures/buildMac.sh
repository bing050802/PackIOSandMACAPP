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

xcodebuild -configuration Release -derivedDataPath "$(BUILDDIR)" build
open -R "$(BUILDDIR)/Build/Products/Release

