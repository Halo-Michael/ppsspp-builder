.PHONY: all clean

all: ipa deb

application:
	sh make-application.sh

ipa: application
	sh make-ipa.sh

deb: application
	sh make-deb.sh

clean:
	rm -rf ppsspp/build-ios *.ipa *.deb
