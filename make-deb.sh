#!/bin/bash

cd ppsspp/build-ios
version_number=`echo "$(git describe --tags --match="v*" | sed -e 's@-\([^-]*\)-\([^-]*\)$@-\1-\2@;s@^v@@;s@%@~@g')"`
package_name="org.ppsspp.ppsspp-dev-latest_0v${version_number}_iphoneos-arm"
mkdir $package_name
mkdir ${package_name}/DEBIAN
cp ../../control ${package_name}/DEBIAN
echo ${version_number} >> ${package_name}/DEBIAN/control
chmod 0755 ${package_name}/DEBIAN/control
mkdir ${package_name}/Library
mkdir ${package_name}/Library/PPSSPPRepoIcons
cp ../../org.ppsspp.ppsspp.png ${package_name}/Library/PPSSPPRepoIcons/org.ppsspp.ppsspp-dev-latest.png
mkdir ${package_name}/Library/PreferenceLoader
cp -a ../../Preferences ${package_name}/Library/PreferenceLoader/
mkdir ${package_name}/Applications
cp -a PPSSPP.app ${package_name}/Applications/
dpkg -b ${package_name} ../../${package_name}.deb
