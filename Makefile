TARGET = PPSSPP

.PHONY: all clean

all: ipa deb

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
