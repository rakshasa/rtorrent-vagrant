# -*- mode: ruby -*-

def deep_symbolize_keys(object)
  case object
  when Array
    object.map { |value|
      deep_symbolize_keys(value)
    }
  when Hash
    object.map { |key, value|
      [key.to_sym, deep_symbolize_keys(value)]
    }.to_h  
  else
    object
  end
end

def node_define_params(node)
  { primary: node[:primary],
    autostart: node.has_key?(:autostart) ? node[:autostart] : true,
  }
end

def disable_default_folder(node_config)
  node_config.vm.synced_folder '.', '/vagrant', disabled: true
end  

def add_local_data(node_config, node_name:, data_user: nil, data_group: nil, should_create: true, auto_cleanup:)
  raise Vagrant::Errors::VagrantError.new, "add_local_data called with no valid 'node_name'" if node_name.nil?

  node_config.vm.synced_folder "./data/#{node_name}", '/data/local', owner: data_user, group: data_group, create: should_create

  node_config.trigger.after :destroy, vm: [node_name], force: true do
    run "rm -rf ./data/#{node_name}" if auto_cleanup
  end
end

def add_shared_data(node_config, node_name:, shared_name:, shared_path: nil, should_create:, should_destroy:)
  raise Vagrant::Errors::VagrantError.new, "add_shared_data called with no valid 'node_name'" if node_name.nil?
  raise Vagrant::Errors::VagrantError.new, "add_shared_data called with no valid 'shared_name'" if shared_name.nil?

  node_config.vm.synced_folder "./data/#{shared_name}", shared_path || "/data/#{shared_name}", create: should_create
  
  if should_create && should_destroy
    node_config.trigger.after :destroy, vm: [node_name], force: true do
      run "rm -rf ./data/#{shared_name}"
    end
  end
end
