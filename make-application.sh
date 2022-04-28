#!/bin/bash

if [[ ! -d ppsspp ]];then
	echo "You are using this script in the wrong path!"
	exit 1
fi

if [[ -d ppsspp/build-ios ]];then
	exit 0
fi

cd ppsspp
echo "const char *PPSSPP_GIT_VERSION = \"$(git describe --always)\";" > git-version.cpp
echo "#define PPSSPP_GIT_VERSION_NO_UPDATE 1" >> git-version.cpp
mkdir build-ios
cd build-ios
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/ios.cmake ..
make -j$(sysctl -n hw.ncpu)
ln -s ./ Payload
ldid -S../../ent.xml -Iorg.ppsspp.ppsspp PPSSPP.app/PPSSPP
version_number=`echo "$(git describe --tags --match="v*" | sed -e 's@-\([^-]*\)-\([^-]*\)$@-\1-\2@;s@^v@@;s@%@~@g')"`
echo ${version_number} > PPSSPP.app/Version.txt
