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

	$(MAKE) clean
	vagrant up
	./scripts/update-ssh-config

	$(MAKE) tracker
	$(MAKE) build_branch
	./scripts/start-rtorrent

# TODO: This may have issues is the rtorrent clients don't shut down
# fast enough. Consider adding a wait thing and do the stop_nodes
# after build, or using a single script.
rebuild:
	./scripts/stop-rtorrent
	./scripts/ssh builder -- "rebuild-rtorrent"
	./scripts/start-rtorrent

check:
	./scripts/stop-rtorrent
	./scripts/ssh builder -- "check-rtorrent"
	./scripts/start-rtorrent

restart:
	./scripts/stop-rtorrent
	./scripts/start-rtorrent

build_branch:
	@echo "Bulding libtorrent '$(LIBTORRENT_BRANCH)' and rtorrent '$(RTORRENT_BRANCH)'."
	./scripts/build-branch $(LIBTORRENT_BRANCH) $(RTORRENT_BRANCH) origin

tracker:
	-./scripts/ssh builder -- "sudo service opentracker stop"
	./scripts/ssh builder -- "IPV4_ONLY=${IPV4_ONLY} build-tracker"
	./scripts/ssh builder -- "sudo service opentracker start"

test_all:
	USE_HTTP_TRACKER=yes USE_UDP_TRACKER=no USE_IPV4=yes USE_IPV6=no ./scripts/new-torrent test_h4
	USE_HTTP_TRACKER=yes USE_UDP_TRACKER=no USE_IPV4=no USE_IPV6=yes ./scripts/new-torrent test_h6
	USE_HTTP_TRACKER=no USE_UDP_TRACKER=yes USE_IPV4=yes USE_IPV6=no ./scripts/new-torrent test_u4
	USE_HTTP_TRACKER=no USE_UDP_TRACKER=yes USE_IPV4=no USE_IPV6=yes ./scripts/new-torrent test_u6

delete_test_all:
	 -./scripts/deactivate-torrent test_h4
	 -./scripts/deactivate-torrent test_h6
	 -./scripts/deactivate-torrent test_u4
	 -./scripts/deactivate-torrent test_u6
	 -./scripts/rm-torrent test_h4
	 -./scripts/rm-torrent test_h6
	 -./scripts/rm-torrent test_u4
	 -./scripts/rm-torrent test_u6

setup:
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-git
	vagrant plugin install vagrant-triggers
	vagrant plugin install vagrant-vbguest

clean:
	-vagrant destroy -f

distclean:
	-vagrant destroy -f
	-rm -rf ./data/*
