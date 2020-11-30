#!/bin/bash

if [[ ! -d ppsspp ]];then
	echo "You are using this script in the wrong path!"
	exit 1
fi

if [[ -d ppsspp/build-ios ]];then
	exit 0
fi

mkdir ppsspp/build-ios
cd ppsspp/build-ios
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/ios.cmake -GXcode ..
xcodebuild clean build -project PPSSPP.xcodeproj CODE_SIGNING_ALLOWED=NO -sdk iphoneos -configuration Release
ln -sf Release-iphoneos Payload
ldid -S../../ent.xml Payload/PPSSPP.app/PPSSPP
version_number=`echo "$(git describe --tags --match="v*" | sed -e 's@-\([^-]*\)-\([^-]*\)$@-\1-\2@;s@^v@@;s@%@~@g')"`
echo ${version_number} > Payload/PPSSPP.app/Version.txt
chown -R 1004:3 Payload
