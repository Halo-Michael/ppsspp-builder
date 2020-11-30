#!/bin/bash

cd ppsspp/build-ios
version_number=`echo "$(git describe --tags --match="v*" | sed -e 's@-\([^-]*\)-\([^-]*\)$@-\1-\2@;s@^v@@;s@%@~@g')"`
zip -r9 ../../PPSSPP_0v${version_number}.ipa Payload/PPSSPP.app
