.PHONY: build

build:
	# build upstream release
	cd lxd-$(LXD_VERSION) && \
		go mod tidy

	$(MAKE) -C lxd-$(LXD_VERSION) deps

	export CGO_CFLAGS="-I$(PWD)/lxd-$(LXD_VERSION)/vendor/raft/include/ -I$(PWD)/lxd-$(LXD_VERSION)/vendor/dqlite/include/" && \
	export CGO_LDFLAGS="-L$(PWD)/lxd-$(LXD_VERSION)/vendor/raft/.libs -L$(PWD)/lxd-$(LXD_VERSION)/vendor/dqlite/.libs/" && \
	export LD_LIBRARY_PATH="$(PWD)/lxd-$(LXD_VERSION)/vendor/raft/.libs/:$(PWD)/lxd-$(LXD_VERSION)/vendor/dqlite/.libs/" && \
	export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)" && \
	$(MAKE) -C lxd-$(LXD_VERSION)

check-env:
ifndef LXD_VERSION
	$(error LXD_VERSION is undefined)
endif

ifeq (, $(shell which go))
 	$(error "No 'go' in $(PATH), please install it "" https://go.dev/doc/install")
endif

lxd-$(LXD_VERSION):
	curl --fail -SOL https://github.com/lxc/lxd/releases/download/lxd-$(LXD_VERSION)/lxd-$(LXD_VERSION).tar.gz
	tar xf lxd-$(LXD_VERSION).tar.gz
	cd lxd-$(LXD_VERSION) && \
		patch -p1  < ../disable-qemu-set-action.patch

prepare: check-env lxd-$(LXD_VERSION)
	sudo apt update
	sudo apt install --yes \
		acl \
		attr \
		autoconf \
		automake \
		dnsmasq-base \
		git \
		libacl1-dev \
		libcap-dev \
		liblxc1 \
		liblxc-dev \
		libsqlite3-dev \
		libtool \
		libudev-dev \
		liblz4-dev \
		libuv1-dev \
		make \
		pkg-config \
		rsync \
		squashfs-tools \
		tar \
		tcl \
		xz-utils \
		ebtables \
		devscripts \
		debhelper \
		shellcheck

pkg:
	mkdir -p pkgdata/lxd/usr/bin/
	mkdir -p pkgdata/lxd-client/usr/bin/
	mkdir -p pkgdata/lxd-agent/usr/bin/
	mkdir -p pkgdata/libdqlite0/usr/lib/x86_64-linux-gnu
	mkdir -p pkgdata/libraft2/usr/lib/x86_64-linux-gnu


	cp $(shell go env GOPATH)/bin/lxd pkgdata/lxd/usr/bin/
	cp $(shell go env GOPATH)/bin/lxd-user pkgdata/lxd/usr/bin/

	cp $(shell go env GOPATH)/bin/lxd-agent pkgdata/lxd-agent/usr/bin/

	cp $(shell go env GOPATH)/bin/lxc pkgdata/lxd-client/usr/bin/

	cp --preserve=links $(PWD)/lxd-$(LXD_VERSION)/vendor/dqlite/.libs/*.so pkgdata/libdqlite0/usr/lib/x86_64-linux-gnu
	cp --preserve=links $(PWD)/lxd-$(LXD_VERSION)/vendor/raft/.libs/*.so pkgdata/libraft2/usr/lib/x86_64-linux-gnu

	@echo "Done building, you can now run:"
	@echo "  debuild --no-tgz-check"
