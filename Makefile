# Current OS X uses GNU Make 3.81 which seems to not properly handle
# dependencies, so use the ugly hack of calling 'make foo' directly.

BRANCH?=master
LIBTORRENT_BRANCH?=$(BRANCH)
RTORRENT_BRANCH?=$(BRANCH)

all:
	@echo "RTorrent Vagrant environment"
	@echo
	@echo "make setup      - install required vagrant plugins"
	@echo "make init       - initialize vms and build rtorrent (support BRANCH, or LIBTORRENT_BRANCH and RTORRENT_BRANCH variables)"
	@echo "make rebuild    - rebuild libtorrent and rtorrent"
	@echo "make check      - rebuild libtorrent and rtorrent with unittests"
	@echo "make test_http4 - creates torrent and attempts to seed it"
	@echo
	@echo "Example:"
	@echo
	@echo "make setup && RTORRENT_BRANCH=feature-foo make init && make test_http4"
	@echo

init:
	@echo "Using branches libtorrent '$(LIBTORRENT_BRANCH)' and rtorrent '$(RTORRENT_BRANCH)'."

	"$(MAKE)" clean
	USE_CONFIG="${USE_CONFIG}" vagrant up
	USE_CONFIG="${USE_CONFIG}" ./scripts/update-ssh-config

	./scripts/build-tracker
	"$(MAKE)" build_branch
	./scripts/config-clear
	./scripts/start-rtorrent

init_v4:
	BRANCH=feature-bind "$(MAKE)" init

rtorrent-dl:
	USE_CONFIG=rtorrent-dl "$(MAKE)" clean
	USE_CONFIG=rtorrent-dl vagrant up
	USE_CONFIG=rtorrent-dl ./scripts/update-ssh-config

	BRANCH=feature-bind "$(MAKE)" build_branch
	./scripts/config-clear
	./scripts/start-rtorrent

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

clean:
	-USE_CONFIG="${USE_CONFIG}" vagrant destroy -f

distclean:
	-vagrant destroy -f
	-rm -rf ./data/*
