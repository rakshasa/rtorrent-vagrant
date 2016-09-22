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
	vagrant ssh node1 -c /home/vagrant/install-rtorrent.sh

setup:
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-git
	vagrant plugin install vagrant-triggers
	vagrant plugin install vagrant-vbguest

tracker:
	vagrant ssh builder -c service opentracker start

clients:
	vagrant ssh node1 -c service rtorrent start

clean:
	-vagrant destroy -f
