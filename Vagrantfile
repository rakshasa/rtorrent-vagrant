# -*- mode: ruby -*-

require './lib/helpers.rb'

# TODO: Move to config file.
DEFAULT_BOX = 'ubuntu/trusty64'

# TODO: Move to dataset file.
nodes = [
  { hostname: 'builder',
    primary: true,
  },
  { hostname: 'node1',
  },
  { hostname: 'node2',
  },
]

Vagrant.configure('2') do |config|
  nodes.each do |node|
    config.vm.define node[:hostname], node_define_params(node) do |node_config|
      node_name = node[:hostname]

      node_config.vm.box = (node[:box] || DEFAULT_BOX)
      node_config.vm.hostname = node_name + '.example.com'

      node_config.vm.network 'private_network', type: 'dhcp'

      add_local_data(node_config, node_name: node_name)
      add_shared_data(node_config, node_name: node_name, shared_name: 'shared', should_create: node[:primary])

      node_config.vm.provider 'virtualbox' do |vb|
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
end
