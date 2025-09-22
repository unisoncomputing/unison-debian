UNISON_NEXT_RELEASE=0.5.49
UNISON_CURRENT_RELEASE=0.5.48
ARCH := $(shell dpkg --print-architecture)

ifeq "$(ARCH)" "arm64"
  UNISON_TRUNK=https://github.com/unisonweb/unison/releases/download/trunk-build/ucm-linux-arm64.tar.gz
  UNISON_RELEASE:=https://github.com/unisonweb/unison/releases/download/release%2F$(UNISON_CURRENT_RELEASE)/ucm-linux-arm64.tar.gz
else
  UNISON_TRUNK=https://github.com/unisonweb/unison/releases/download/trunk-build/ucm-linux-x64.tar.gz
  UNISON_RELEASE:=https://github.com/unisonweb/unison/releases/download/release%2F$(UNISON_CURRENT_RELEASE)/ucm-linux-x64.tar.gz
endif

TRUNK_VERSION := $(UNISON_NEXT_RELEASE)~trunk+$(shell date '+%Y%m%d')

APTLY_URI := $(shell dig +short -t SRV aptly.service.us-west-2.consul.unison-lang.org | awk '{print "http://" $$4 ":" $$3}')

SPACKAGE := $(shell dpkg-parsechangelog -S source)
DIST := bookworm



TRUNK_DEB := ../$(SPACKAGE)_$(TRUNK_VERSION)_$(ARCH).deb
RELEASE_DEB := ../$(SPACKAGE)_$(UNISON_CURRENT_RELEASE)_$(ARCH).deb
CHANGES := ../$(SPACKAGE)_$(UNISON_CURRENT_RELEASE)_$(ARCH).changes

$(CHANGES): debian/*
	dpkg-buildpackage -rfakeroot -uc -us

build: $(CHANGES)

v:
	@echo $(APTLY_URI)

$(TRUNK_DEB):
	wget -O ucm-linux.tar.gz $(UNISON_TRUNK)
	dch -b --distribution bookworm -v $(TRUNK_VERSION) "Nightly build"
	dpkg-buildpackage -rfakeroot -uc -us

$(RELEASE_DEB):
	wget -O ucm-linux.tar.gz $(UNISON_RELEASE)
	dch -b --distribution bookworm -v $(UNISON_CURRENT_RELEASE) "Release build"
	dpkg-buildpackage -rfakeroot -uc -us

upload-trunk: $(TRUNK_DEB)
	curl -X POST -F file=@$(TRUNK_DEB) $(APTLY_URI)/api/files/$(SPACKAGE)
	curl -X POST $(APTLY_URI)/api/repos/trixie-nightly/file/$(SPACKAGE)
	curl -X PUT -H 'Content-Type: application/json' -d '{"ForceOverwrite": true}' $(APTLY_URI)/api/publish//trixie

upload-release: $(RELEASE_DEB)
	curl -X POST -F file=@$(RELEASE_DEB) $(APTLY_URI)/api/files/$(SPACKAGE)
	curl -X POST $(APTLY_URI)/api/repos/trixie-release/file/$(SPACKAGE)
	curl -X PUT -H 'Content-Type: application/json' -d '{"ForceOverwrite": true}' $(APTLY_URI)/api/publish//trixie

.PHONY: build upload-trunk v
