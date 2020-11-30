#!/bin/bash

cd ppsspp/build-ios
zip -r9 ../../PPSSPP_0v${version_number}.ipa Payload/PPSSPP.app
