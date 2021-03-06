# Current OS X uses GNU Make 3.81 which seems to not properly handle
# dependencies, so use the ugly hack of calling 'make foo' directly.

BRANCH?=master
LIBTORRENT_BRANCH?=$(BRANCH)
RTORRENT_BRANCH?=$(BRANCH)

export USE_CONFIG?=$(shell cat ./data/current-config 2> /dev/null || echo default)
export VAGRANT_USE_VAGRANT_TRIGGERS=1

all:
	@echo "RTorrent Vagrant environment"
	@echo
	@echo "make setup      - install required vagrant plugins"
	@echo "make init       - initialize vms and build rtorrent (support BRANCH, or LIBTORRENT_BRANCH and RTORRENT_BRANCH variables)"
	@echo "make rebuild    - rebuild libtorrent and rtorrent"

init:
	@echo "Using branches libtorrent '$(LIBTORRENT_BRANCH)' and rtorrent '$(RTORRENT_BRANCH)'."

	-"$(MAKE)" clean

	./scripts/build-set-config "$(USE_CONFIG)"
	vagrant up
	./scripts/update-current-nodes
	./scripts/update-ssh-service
	./scripts/update-ssh-config

	./scripts/build-git-clone
	./scripts/build-tracker
	"$(MAKE)" build_branch
	./scripts/build-tags
	./scripts/config-clear
	./scripts/ip-dns-config default
	./scripts/ip-dns-resolver default
	./scripts/start-rtorrent

feature-bind:
	./scripts/build-set-config "default"
	BRANCH=feature-bind USE_CONFIG=default "$(MAKE)" init

node-dl:
	./scripts/build-set-config "rtorrent-dl"
	BRANCH=feature-bind USE_CONFIG=rtorrent-dl "$(MAKE)" init

	vagrant destroy -f builder

	./scripts/config-enable-dht-global "shared"
	"$(MAKE)" restart

# TODO: This may have issues is the rtorrent clients don't shut down
# fast enough. Consider adding a wait thing and do the stop_nodes
# after build, or using a single script.
rebuild:
	./scripts/stop-rtorrent
	./scripts/build-current
	./scripts/start-rtorrent -s

rebuild_rtorrent:
	./scripts/stop-rtorrent
	SKIP_LIBTORRENT=yes ./scripts/build-current
	./scripts/start-rtorrent -s

check:
	./scripts/stop-rtorrent
	./scripts/ssh builder -- "check-libtorrent"
	./scripts/ssh builder -- "check-rtorrent"
	./scripts/start-rtorrent -s

check_rtorrent:
	./scripts/stop-rtorrent
	./scripts/ssh builder -- "check-rtorrent"
	./scripts/start-rtorrent -s

restart:
	./scripts/stop-rtorrent
	sleep 2
	./scripts/start-rtorrent -s

build_branch:
	@echo "Bulding libtorrent '$(LIBTORRENT_BRANCH)' and rtorrent '$(RTORRENT_BRANCH)'."
	./scripts/build-branch $(LIBTORRENT_BRANCH) $(RTORRENT_BRANCH)

tags:
	find scripts -name '[a-z0-9/-]*' | etags -

setup:
	vagrant plugin install vagrant-vbguest
	vagrant plugin install vagrant-disksize
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-triggers

# Change to also destroy all found nodes.
clean:
	-./scripts/stop-rtorrent
	-vagrant destroy -f

distclean:
	-./scripts/stop-rtorrent
	-vagrant destroy -f
	-rm -rf ./data/*
