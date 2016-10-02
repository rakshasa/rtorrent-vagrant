all: clean
	make build
	make nodes
	make tracker
	make clients

build:
	vagrant up builder
	vagrant ssh builder -c /home/vagrant/build-rtorrent
	vagrant ssh builder -c /home/vagrant/build-tracker

nodes:
	vagrant up node1
	vagrant up node2
	vagrant ssh node1 -c /home/vagrant/install-rtorrent
	vagrant ssh node2 -c /home/vagrant/install-rtorrent

setup:
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-git
	vagrant plugin install vagrant-triggers
	vagrant plugin install vagrant-vbguest

tracker:
	vagrant ssh builder -c "/home/vagrant/run-tracker"

clients:
	vagrant ssh node1 -c "/home/vagrant/run-rtorrent"
	vagrant ssh node2 -c "/home/vagrant/run-rtorrent"

node1screen:
	vagrant ssh node1 -c "sudo -u rtorrent bash -c 'script -qc \"screen -r\" /dev/null'"

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

# TODO: Add script to show all torrent states of all nodes using xmlrpc.

clean:
	-vagrant destroy -f
