all: clean
	make build
	make nodes
	make tracker
	make clients

build:
	vagrant up builder
	vagrant ssh builder -c /home/vagrant/build-rtorrent.sh
	vagrant ssh builder -c /home/vagrant/build-tracker.sh

nodes:
	vagrant up node1
	vagrant up node2
	vagrant ssh node1 -c /home/vagrant/install-rtorrent.sh
	vagrant ssh node2 -c /home/vagrant/install-rtorrent.sh

setup:
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-git
	vagrant plugin install vagrant-triggers
	vagrant plugin install vagrant-vbguest

tracker:
	vagrant ssh builder -c "/home/vagrant/run-tracker.sh"

clients:
	vagrant ssh node1 -c "/home/vagrant/run-rtorrent.sh"
	vagrant ssh node2 -c "/home/vagrant/run-rtorrent.sh"

node1screen:
	vagrant ssh node1 -c "sudo -u rtorrent bash -c 'script -qc \"screen -r\" /dev/null'"

clean:
	-vagrant destroy -f
