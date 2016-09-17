# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # config.vm.box = 'hashicorp/precise64'
  config.vm.box = 'ubuntu/trusty64'

  config.vm.synced_folder './data', '/data'

  #config.vm.network 'public_network', type: 'dhcp', auto_config: false
  config.vm.network 'private_network', type: 'dhcp'

  config.vbguest.auto_update = false
  config.vbguest.installer_arguments = ['--nox11']

  # config.vm.provider 'virtualbox' do |vb|
  #   vb.memory = '1024'
  # end

  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
  end

  config.vm.provision 'puppet' do |puppet|
    puppet.manifest_file  = 'test.pp'
    puppet.manifests_path = 'puppet/manifests'
    puppet.module_path = 'puppet/modules'
  end

  config.git.add_repo do |rc|
    rc.target = 'git@github.com:rakshasa/libtorrent.git'
    rc.path = './data/libtorrent'
    rc.branch = 'master'
  end

  config.git.add_repo do |rc|
    rc.target = 'git@github.com:rakshasa/rtorrent.git'
    rc.path = './data/rtorrent'
    rc.branch = 'master'
  end

  config.trigger.after :destroy do
    run 'rm -Rf data/rtorrent'
    run 'rm -Rf data/libtorrent'
  end

end
