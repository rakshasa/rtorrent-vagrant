# Current OS X uses GNU Make 3.81 which seems to not properly handle
# dependencies, so use the ugly hack of calling 'make foo' directly.

BRANCH?=master
LIBTORRENT_BRANCH?=$(BRANCH)
RTORRENT_BRANCH?=$(BRANCH)

all:
	@echo "Call a proper make thing."

init:
	@echo "Using branches libtorrent '$(LIBTORRENT_BRANCH)' and rtorrent '$(RTORRENT_BRANCH)'."

	$(MAKE) clean
	vagrant up builder
	vagrant up node1
	vagrant up node2
	$(MAKE) ssh_config

	$(MAKE) tracker
	$(MAKE) build_branch
	$(MAKE) start_nodes

init_builder:
	@echo "Using branches libtorrent '$(LIBTORRENT_BRANCH)' and rtorrent '$(RTORRENT_BRANCH)'."

	$(MAKE) clean
	vagrant up builder
	$(MAKE) ssh_config

ssh_config:
	vagrant ssh-config > ./data/ssh-config

# TODO: This may have issues is the rtorrent clients don't shut down
# fast enough. Consider adding a wait thing and do the stop_nodes
# after build, or using a single script.
rebuild:
	$(MAKE) stop_nodes
	./scripts/ssh builder -- "/home/vagrant/rebuild-rtorrent"
	$(MAKE) start_nodes

build_branch:
	@echo "Bulding libtorrent '$(LIBTORRENT_BRANCH)' and rtorrent '$(RTORRENT_BRANCH)'."
	./scripts/build-branch $(LIBTORRENT_BRANCH) $(RTORRENT_BRANCH) origin

tracker:
	./scripts/ssh builder -- "/home/vagrant/build-tracker"
	./scripts/ssh builder -- "sudo service opentracker start"

start_nodes:
	./scripts/ssh node1 -- "/home/vagrant/run-rtorrent"
	./scripts/ssh node2 -- "/home/vagrant/run-rtorrent"

stop_nodes:
	./scripts/ssh node1 -- "/home/vagrant/stop-rtorrent"
	./scripts/ssh node2 -- "/home/vagrant/stop-rtorrent"

test_udp4_tracker:
	USE_HTTP_TRACKER=no USE_UDP_TRACKER=yes USE_IPV4=yes USE_IPV6=no ./scripts/new-torrent test_udp4_1

test_udp6_tracker:
	USE_HTTP_TRACKER=no USE_UDP_TRACKER=yes USE_IPV4=no USE_IPV6=yes ./scripts/new-torrent test_udp6_1

test_http4:
	USE_HTTP_TRACKER=yes USE_UDP_TRACKER=no USE_IPV4=yes USE_IPV6=no ./scripts/new-torrent test_http4

enable_inet_node1:
	./scripts/ssh node1 -- "/home/vagrant/enable-inet"

enable_inet_node2:
	./scripts/ssh node2 -- "/home/vagrant/enable-inet"

disable_inet_node1:
	./scripts/ssh node1 -- "/home/vagrant/disable-inet"

disable_inet_node2:
	./scripts/ssh node2 -- "/home/vagrant/disable-inet"

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
