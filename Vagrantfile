# -*- mode: ruby -*-

require 'json'
require './lib/helpers.rb'

Vagrant.require_version ">= 1.8.0"

# TODO: Move to config file.
DEFAULT_BOX = 'ubuntu/trusty64'

nodes = [
  { hostname: 'builder',
    primary: true,
    builder: true,
    cpus: 8,
    memory: 2048,
    ipv6: '10',
  },
  { hostname: 'node1',
    ipv6: '11',
  },
  { hostname: 'node2',
    ipv6: '12',
  },
]

CONFIG_DIR = 'config/'
#nodes = JSON.parse(File.read(File.join(CONFIG_DIR, 'base.nodes')))

Vagrant.configure('2') do |config|
  nodes.each do |node|
    node_name = node[:hostname]

    config.vm.define node_name, node_define_params(node) do |node_config|
      node_config.vm.box = (node[:box] || DEFAULT_BOX)
      node_config.vm.hostname = node_name + '.example.com'

      # The VirtualBox host-only network should have a private IPv6
      # subnet in 'fc00::/7', e.g. 'fdcc::/16'.
      node_config.vm.network 'private_network', type: 'dhcp'

      disable_default_folder(node_config)

      add_local_data(node_config, node_name: node_name, auto_cleanup: !node[:builder])
      add_shared_data(node_config, node_name: node_name, shared_name: 'shared', should_create: node[:primary])
      add_shared_data(node_config, node_name: node_name, shared_name: 'usr_local', shared_path: '/usr/local', should_create: node[:primary])

      node_config.trigger.after :up do
        run_remote "/home/vagrant/change-inet6 fdcc::#{node[:ipv6]}/16"
        run_remote '/home/vagrant/update-metadata'
      end

      node_config.vm.provider 'virtualbox' do |vb|
        vb.name = "rtorrent-#{node_name}"
        vb.linked_clone = true

        vb.cpus = node[:cpus] if node[:cpus]
        vb.memory = node[:memory] if node[:memory]
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
  end

  add_builder_repo(config, repo_name: 'libtorrent')
  add_builder_repo(config, repo_name: 'rtorrent')
  add_builder_repo(config, repo_name: 'opentracker')

  config.trigger.after :destroy, vm: ['builder'], force: true do
    run './scripts/clean-builder'
  end

end
