# Current OS X uses GNU Make 3.81 which seems to not properly handle
# dependencies, so use the ugly hack of calling 'make foo' directly.

all:
	@echo "Call a proper make thing."

init:
	$(MAKE) clean
	vagrant up builder
	$(MAKE) tracker
	$(MAKE) build_ipv6
	$(MAKE) disable_inet_node2
	$(MAKE) nodes

build_ipv6:
	./scripts/build-branch ipv6

tracker:
	vagrant ssh builder -c "/home/vagrant/build-tracker"
	vagrant ssh builder -c "sudo service opentracker start"

nodes:
	vagrant up node1
	vagrant up node2
	vagrant ssh node1 -c "sudo service rtorrent start"
	vagrant ssh node2 -c "sudo service rtorrent start"

activate_test1:
	./scripts/make-torrent test1
	./scripts/activate-torrent test1

activate_test2:
	./scripts/make-torrent test2
	./scripts/activate-torrent test2

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
