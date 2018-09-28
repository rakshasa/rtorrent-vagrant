# Current OS X uses GNU Make 3.81 which seems to not properly handle
# dependencies, so use the ugly hack of calling 'make foo' directly.

BRANCH?=master
LIBTORRENT_BRANCH?=$(BRANCH)
RTORRENT_BRANCH?=$(BRANCH)

export USE_CONFIG?=$(shell cat ./data/current-config || echo default)
export VAGRANT_USE_VAGRANT_TRIGGERS=1

all:
	@echo "RTorrent Vagrant environment"
	@echo
	@echo "make setup      - install required vagrant plugins"
	@echo "make init       - initialize vms and build rtorrent (support BRANCH, or LIBTORRENT_BRANCH and RTORRENT_BRANCH variables)"
	@echo "make rebuild    - rebuild libtorrent and rtorrent"

init:
	@echo "Using branches libtorrent '$(LIBTORRENT_BRANCH)' and rtorrent '$(RTORRENT_BRANCH)'."

	"$(MAKE)" clean

	echo "$(USE_CONFIG)" > ./data/current-config
	vagrant up
	./scripts/update-ssh-config

	./scripts/build-tracker
	"$(MAKE)" build_branch
	./scripts/config-clear
	./scripts/start-rtorrent

feature-bind:
	echo "default" > ./data/current-config
	BRANCH=feature-bind USE_CONFIG=default "$(MAKE)" init

node-dl:
	echo "rtorrent-dl" > ./data/current-config
	BRANCH=feature-bind USE_CONFIG=rtorrent-dl "$(MAKE)" init

	vagrant destroy -f builder

# TODO: This may have issues is the rtorrent clients don't shut down
# fast enough. Consider adding a wait thing and do the stop_nodes
# after build, or using a single script.
rebuild:
	./scripts/rebuild
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

setup:
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-disksize
	vagrant plugin install vagrant-git
	vagrant plugin install vagrant-triggers
	vagrant plugin install vagrant-vbguest

# Change to also destroy all found nodes.
clean:
	-vagrant destroy -f

distclean:
	-vagrant destroy -f
	-rm -rf ./data/*
