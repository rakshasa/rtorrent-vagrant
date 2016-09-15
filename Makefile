all: up

up:
	vagrant up

setup:
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-git
	vagrant plugin install vagrant-vbguest

clean:
	-vagrant destroy -f
	-rm -rf data/*
