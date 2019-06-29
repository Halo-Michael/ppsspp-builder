#!/bin/bash

if [[ ! -d ppsspp ]];then
	echo "You are using this script in the wrong path!"
	exit 1
fi

if [[ ! -d ppsspp/build-ios/PPSSPP.xcodeproj ]];then
	echo "Please make sure you are using the early xcode command line tools like Xcode 9.4."
	cd ppsspp
	mkdir build-ios
	cd build-ios
	cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/ios.cmake -GXcode ..
	echo "Done, you should change to use the latest xcode command line tools like Xcode 10.1 to complete the next steps."
else
	echo "Please make sure you are using the latest xcode command line tools like Xcode 10.1."
	cd ppsspp/build-ios
	xcodebuild clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO PRODUCT_BUNDLE_IDENTIFIER="org.ppsspp.ppsspp" -sdk iphoneos -configuration Release
	ln -sf Release-iphoneos Payload
	echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>platform-application</key>
	<true/>
	<key>com.apple.private.security.no-container</key>
	<true/>
	<key>get-task-allow</key>
	<true/>
</dict>
</plist>' > ent.xml
	ldid -Sent.xml Payload/PPSSPP.app/PPSSPP
	version_number=`echo "$(git describe --tags --match="v*" | sed -e 's@-\([^-]*\)-\([^-]*\)$@-\1-\2@;s@^v@@;s@%@~@g')"`
	echo ${version_number} > Payload/PPSSPP.app/Version.txt
	zip -r9 ../../PPSSPP_0v${version_number}.ipa Payload/PPSSPP.app
	echo "Done, you should get the ipa now :)"
fi