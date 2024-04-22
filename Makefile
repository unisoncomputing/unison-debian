UNISON_RELEASE:=https://github.com/unisonweb/unison/releases/download/trunk-build/ucm-linux.tar.gz

DEBIAN_VERSION := $(shell dpkg-parsechangelog -S version)
SPACKAGE := $(shell dpkg-parsechangelog -S source)
DIST := $(shell dpkg-parsechangelog -S distribution)
ARCH := $(shell dpkg --print-architecture)
CHANGES := ../$(SPACKAGE)_$(DEBIAN_VERSION)_$(ARCH).changes

$(CHANGES): debian/*
	dpkg-buildpackage -rfakeroot -uc -us

build: $(CHANGES)

upload: $(CHANGES)
	if [ $(DIST) != "UNRELEASED" ]; then \
		for f in $(shell dcmd $(CHANGES)); do \
			aws s3 cp "$$f" s3://unison-debian-packages/$(DIST)/ ;\
		 done ; \
	fi \

.PHONY: build upload