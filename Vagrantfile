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

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define 'atlas' do |push|
  #   push.app = 'YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME'
  # end

  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
  end

  # Suppress TTY related warnings.
  config.vm.provision 'fix-no-tty', type: :shell do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision 'puppet' do |puppet|
    puppet.manifest_file  = 'main.pp'
  end

  # config.vm.provision :shell, inline: 'apt-get update --fix-missing'

  # if true
  #   config.vm.provision :shell, inline: 'apt-get install -y g++-4.8'
  #   config.vm.provision :shell, inline: 'apt-get install -y automake libtool make pkg-config git-core'
  #   config.vm.provision :shell, inline: 'apt-get install -y libcppunit-dev libcurl4-openssl-dev libncurses5-dev libxmlrpc-core-c3-dev'
  # else
  #   config.vm.provision :shell, inline: 'apt-get install -y libcurl4-openssl libxmlrpc-core-c3'
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision :shell, inline: <<-SHELL
  #   echo "LD_LIBRARY_PATH=\"/usr/local/lib`" >> /etc/environment
  # SHELL

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
    run 'rm -Rf data/*'
  end

end
