.PHONY: all clean

SED=/usr/local/Cellar/gnu-sed/4.8/libexec/gnubin/sed
MAKE=/usr/local/Cellar/make/4.3/libexec/gnubin/make

all: ipa deb

application:
	if [[ ! -d ppsspp ]]; \
	then \
		echo "You are using this script in the wrong path!"; \
		exit 1; \
	fi; \
	if [[ -d ppsspp/build-ios ]]; \
	then \
		exit 0; \
	fi; \
	cd ppsspp; \
	echo "const char *PPSSPP_GIT_VERSION = \"$$(git describe --always)\";" > git-version.cpp; \
	echo "#define PPSSPP_GIT_VERSION_NO_UPDATE 1" >> git-version.cpp; \
	mkdir build-ios; \
	cd build-ios; \
	cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/ios.cmake ..; \
	${MAKE} -j$$(sysctl -n hw.ncpu); \
	ln -s ./ Payload; \
	ldid -S../../ent.xml -Iorg.ppsspp.ppsspp PPSSPP.app/PPSSPP; \
	echo $$(git describe --tags --match="v*" | ${SED} -e 's@-\([^-]*\)-\([^-]*\)$$@-\1-\2@;s@^v@@;s@%@~@g') > PPSSPP.app/Version.txt

ipa: application
	cd ppsspp/build-ios; \
	version_number=$$(git describe --tags --match="v*" | ${SED} -e 's@-\([^-]*\)-\([^-]*\)$$@-\1-\2@;s@^v@@;s@%@~@g'); \
	zip -r9 ../../PPSSPP_0v$${version_number}.ipa Payload/PPSSPP.app; \

deb: application
	cd ppsspp/build-ios; \
	version_number=$$(git describe --tags --match="v*" | ${SED} -e 's@-\([^-]*\)-\([^-]*\)$$@-\1-\2@;s@^v@@;s@%@~@g'); \
	package_name="org.ppsspp.ppsspp-dev-latest_0v$${version_number}_iphoneos-arm"; \
	mkdir $$package_name; \
	mkdir $${package_name}/DEBIAN; \
	cp ../../control $${package_name}/DEBIAN; \
	echo $${version_number} >> $${package_name}/DEBIAN/control; \
	chmod 0755 $${package_name}/DEBIAN/control; \
	mkdir $${package_name}/Library; \
	mkdir $${package_name}/Library/PPSSPPRepoIcons; \
	cp ../../org.ppsspp.ppsspp.png $${package_name}/Library/PPSSPPRepoIcons/org.ppsspp.ppsspp-dev-latest.png; \
	mkdir $${package_name}/Library/PreferenceLoader; \
	mkdir $${package_name}/Library/PreferenceLoader/Preferences; \
	cp -a ../../Preferences/PPSSPP $${package_name}/Library/PreferenceLoader/Preferences/; \
	mkdir $${package_name}/Applications; \
	cp -a PPSSPP.app $${package_name}/Applications/; \
	dpkg -b $${package_name} ../../$${package_name}.deb

clean:
	rm -rf ppsspp/git-version.cpp ppsspp/build-ios *.ipa *.deb
