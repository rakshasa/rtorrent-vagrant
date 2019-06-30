# -*- mode: ruby -*-

require './lib/config.rb'
require './lib/helpers.rb'
require './lib/network.rb'

# TODO: Move to config file.
DEFAULT_BOX = 'ubuntu/trusty64'
CONFIG_DIR = 'config/'

Vagrant.require_version ">= 1.8.0"

config_name = ENV['USE_CONFIG'].to_s.empty? ? 'default' : ENV['USE_CONFIG']
global_config = parse_config_file(config_name)

Vagrant.configure('2') do |config|
  global_config[:nodes].each do |node|
    name = node[:name]
    vm_name = node[:vm_name] || name

    config.vm.define name, node_define_params(node) do |node_config|
      node_config.vm.box = (node[:box] || DEFAULT_BOX)
      node_config.vm.hostname = name + '.example.com'

      configure_networks(node_config, node)

      disable_default_folder(node_config)

      add_local_data(node_config, node_name: name,
                     auto_cleanup: !node[:builder])
      add_shared_data(node_config, node_name: name,
                      shared_name: 'shared',
                      should_create: node[:primary],
                      should_destroy: false)
      add_shared_data(node_config, node_name: name,
                      shared_name: 'usr_local',
                      shared_path: '/usr/local',
                      should_create: node[:primary],
                      should_destroy: false)

      node_config.vm.synced_folder "./scripts/node", "/data/scripts"

      # Change how update-metadata handles disabling of inet.
      node_config.trigger.after :up do
        run_remote '/data/scripts/update-metadata'
      end

      node_config.vm.provider 'virtualbox' do |vb|
        vb.name = "rtorrent-#{vm_name}"
        vb.linked_clone = true

        vb.cpus = node[:cpus] if node[:cpus]
        vb.memory = node[:memory] if node[:memory]
        vb.disksize.size = node[:disk_size] if node[:disk_size]

        vb.customize ["modifyvm", :id, "--groups", "/rtorrent-#{config_name}"]
      end

      node_config.vm.provision 'puppet' do |puppet|
        puppet.manifests_path = 'puppet/manifests'
        puppet.module_path = 'puppet/modules'
        #puppet.options="--verbose --debug"
      end
    end
  end

  config.vbguest.auto_update = false
  config.vbguest.installer_arguments = ['--nox11']

  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :box
    config.cache.enable :apt_lists
    config.cache.auto_detect = true
  end

  config.trigger.after :destroy, vm: ['builder'], force: true do
    run 'bash ./scripts/clean-builder'
  end

end
