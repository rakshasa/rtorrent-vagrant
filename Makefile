all: up

up:
	vagrant up

build:
	vagrant ssh -c /home/vagrant/build-rtorrent.sh

setup:
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-git
	vagrant plugin install vagrant-triggers
	vagrant plugin install vagrant-vbguest

clean:
	-vagrant destroy -f
