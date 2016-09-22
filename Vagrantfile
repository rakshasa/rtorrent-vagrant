# -*- mode: ruby -*-
# vi: set ft=ruby :

# TODO: Move to config file.
DEFAULT_BOX = 'ubuntu/trusty64'

# TODO: Move to dataset file.
nodes = [
  { hostname: 'builder',
    data: 'builder',
    primary: true,
    autostart: false
  },
  { hostname: 'node1',
    autostart: false
  },
]

# TODO: Move to helper method file.
def node_data_folder(node)
  "./data/#{node[:data]}"
end

def node_define_params(node)
  { primary: node[:primary],
    autostart: (node[:autostart] || true)
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

Vagrant.configure('2') do |config|
  nodes.each do |node|
    config.vm.define node[:hostname], node_define_params(node) do |node_config|
      node_config.vm.box = (node[:box] || DEFAULT_BOX)
      node_config.vm.hostname = node[:hostname] + '.example.com'

      node_config.vm.synced_folder './data/shared', '/data/shared'
      node_config.vm.synced_folder node_data_folder(node), '/data/local' if node[:data]

      node_config.vm.network 'private_network', type: 'dhcp'

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
    run "rm -rf ./data/shared/pkg"
  end
end
