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
#	$(MAKE) disable_inet_node1
#	$(MAKE) disable_inet_node2
	$(MAKE) start_nodes

ssh_config:
	vagrant ssh-config > ./data/ssh-config

# TODO: This may have issues is the rtorrent clients don't shut down
# fast enough. Consider adding a wait thing and do the stop_nodes
# after build, or using a single script.
rebuild:
	$(MAKE) stop_nodes
	vagrant ssh builder -c "/home/vagrant/rebuild-rtorrent"
	$(MAKE) start_nodes

build_branch:
	@echo "Bulding libtorrent '$(LIBTORRENT_BRANCH)' and rtorrent '$(RTORRENT_BRANCH)'."
	./scripts/build-branch $(LIBTORRENT_BRANCH) $(RTORRENT_BRANCH) origin

tracker:
	vagrant ssh builder -c "/home/vagrant/build-tracker"
	vagrant ssh builder -c "sudo service opentracker start"

start_nodes:
	vagrant ssh node1 -c "/home/vagrant/run-rtorrent"
	vagrant ssh node2 -c "/home/vagrant/run-rtorrent"

stop_nodes:
	vagrant ssh node1 -c "/home/vagrant/stop-rtorrent"
	vagrant ssh node2 -c "/home/vagrant/stop-rtorrent"

# activate_test2:
# 	./scripts/new-torrent test2

enable_inet_node1:
	vagrant ssh node1 -c "/home/vagrant/enable-inet"

enable_inet_node2:
	vagrant ssh node2 -c "/home/vagrant/enable-inet"

disable_inet_node1:
	vagrant ssh node1 -c "/home/vagrant/disable-inet"

disable_inet_node2:
	vagrant ssh node2 -c "/home/vagrant/disable-inet"

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
