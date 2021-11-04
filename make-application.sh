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
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/ios.cmake ..
make -j8
cp ../ext/vulkan/iOS/Frameworks/libMoltenVK.dylib PPSSPP.app/Frameworks
ln -s ./ Payload
mv PPSSPP.app/PPSSPP PPSSPP.app/org.ppsspp.ppsspp
ldid -S../../ent.xml PPSSPP.app/org.ppsspp.ppsspp
mv PPSSPP.app/org.ppsspp.ppsspp PPSSPP.app/PPSSPP
version_number=`echo "$(git describe --tags --match="v*" | sed -e 's@-\([^-]*\)-\([^-]*\)$@-\1-\2@;s@^v@@;s@%@~@g')"`
echo ${version_number} > PPSSPP.app/Version.txt
