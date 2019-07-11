TARGET = PPSSPP

.PHONY: all clean

all:
	sh make-all.sh

quickall:
	sh quick-make-all.sh

ipa:
	sh make-ipa.sh

deb:
	sh make-deb.sh

quickipa:
	sh quick-make-ipa.sh

quickdeb:
	sh quick-make-deb.sh

clean:
	rm -rf ppsspp/build-ios *.ipa *.deb
