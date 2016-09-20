all: clean
	make build
	make nodes

build:
	vagrant up builder
	vagrant ssh builder -c /home/vagrant/build-rtorrent.sh

nodes:
	vagrant up node1
	vagrant ssh node1 -c /home/vagrant/install-rtorrent.sh

setup:
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-git
	vagrant plugin install vagrant-triggers
	vagrant plugin install vagrant-vbguest

clean:
	-vagrant destroy -f
