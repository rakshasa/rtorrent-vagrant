# -*- mode: ruby -*-
# vi: set ft=ruby :

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

def node_define_params(node)
  { primary: node[:primary],
    autostart: node[:autostart]
  }
end

def add_builder_repo(config, repo_name:, repo_branch: 'master', repo_root: 'git@github.com:rakshasa')
  config.git.add_repo { |rc|
    rc.target = "#{repo_root}/#{repo_name}.git"
    rc.path = "./data/builder/#{repo_name}"
    rc.branch = repo_branch
  }

  config.trigger.after :destroy, vm: ['builder'], force: true do
    run "rm -rf ./data/builder/#{repo_name}"
  end
end

def add_data_local(config, node_name:, data_user: nil, data_group: nil, should_create: true)
  if node_name.nil?
    raise Vagrant::Errors::VagrantError.new, "add_data_local called for '#{node[:hostname]}' with no valid 'node_name:'"
  end

  config.vm.synced_folder "./data/#{node_name}", '/data/local', owner: data_user, group: data_group, create: should_create

  config.trigger.after :destroy, vm: [node_name], force: true do
    run "rm -rf ./data/#{node_name}"
  end
end

Vagrant.configure('2') do |config|
  nodes.each do |node|
    config.vm.define node[:hostname], node_define_params(node) do |node_config|
      node_name = node[:hostname]

      node_config.vm.box = (node[:box] || DEFAULT_BOX)
      node_config.vm.hostname = node_name + '.example.com'

      node_config.vm.network 'private_network', type: 'dhcp'
      node_config.vm.synced_folder './data/shared', '/data/shared', create: node[:primary]

      add_data_local(node_config,
                     node_name: node_name,
                     data_user: node[:data_user], data_group: node[:data_group])

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

  config.trigger.after :destroy, vm: ['builder'], force: true do
    run "rm -rf ./data/shared"
  end
end
