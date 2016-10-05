# -*- mode: ruby -*-

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

def add_local_data(config, node_name:, data_user: nil, data_group: nil, should_create: true)
  if node_name.nil?
    raise Vagrant::Errors::VagrantError.new, "add_local_data called with no valid 'node_name'"
  end

  config.vm.synced_folder "./data/#{node_name}", '/data/local', owner: data_user, group: data_group, create: should_create

  config.trigger.after :destroy, vm: [node_name], force: true do
    run "rm -rf ./data/#{node_name}"
  end
end

def add_shared_data(config, node_name:, shared_name:, shared_path: nil, should_create:)
  if node_name.nil?
    raise Vagrant::Errors::VagrantError.new, "add_local_data called with no valid 'node_name'"
  end

  if shared_name.nil?
    raise Vagrant::Errors::VagrantError.new, "add_shared_data called with no valid 'shared_name'"
  end

  config.vm.synced_folder "./data/#{shared_name}", shared_path || "/data/#{shared_name}", create: should_create

  if should_create
    config.trigger.after :destroy, vm: [node_name], force: true do
      run "rm -rf ./data/#{shared_name}"
    end
  end
end
