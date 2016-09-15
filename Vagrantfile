# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Workaround for NFS...
  #config.vm.network "private_network", ip: "192.168.50.4"
  #config.vm.synced_folder ".", "/vagrant", type: "nfs"
 
  #config.vm.network "public_network", type: "dhcp", auto_config: false
  config.vm.network "private_network", type: "dhcp", auto_config: false

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  config.vm.synced_folder './data', '/data', type: "nfs"

  if Vagrant.has_plugin?('vagrant-cachier')
    #config.cache.scope = :machine
    config.cache.scope = :box

    # config.cache.synced_folder_opts = {
    #   type: :nfs,
    #   mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    # }
  end

  config.vm.post_up_message = "Using vagrant-cachier with '#{config.cache.scope}' scope"

  # Suppress TTY related warnings.
  config.vm.provision 'fix-no-tty', type: 'shell' do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provision 'shell', inline: 'apt-get update --fix-missing'
  config.vm.provision 'shell', inline: 'apt-get install -y g++-4.6 make pkg-config git-core libcppunit-dev libcurl4-openssl-dev libxmlrpc-core-c3-dev'

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision 'shell', inline: <<-SHELL
  SHELL

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

end
