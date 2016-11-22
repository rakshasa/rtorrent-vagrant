# -*- mode: ruby -*-

def configure_networks(node, config)
  # The VirtualBox host-only network should have a private IPv6
  # subnet in 'fc00::/7', e.g. 'fdcc::/16'.
  node.vm.network 'private_network', type: 'dhcp'
  #node.vm.network 'private_network', type: 'static', ip: "fddd::#{config[:ipv6]}/16"

  config[:forward] && config[:forward].each { |params| # Replace with named args.
    if !valid_port(params[:guest]) || !valid_port(params[:host])
      raise Vagrant::Errors::ConfigInvalid.new
    end

    node.vm.network 'forwarded_port', guest: params[:guest], host: params[:host]

    node.trigger.after :up do
      run_remote "echo #{params[:host]} > /data/local/metadata/forward.#{params[:guest]}"
    end
  }
  
  node.trigger.after :up do
    if config[:ipv6]
      run_remote "/home/vagrant/change-inet6 fdcc::#{config[:ipv6]}/16"
    else
      run_remote "/home/vagrant/disable-inet6"
    end
  end
end

def valid_port(port, allow_nil: false)
  (port || allow_nil) && port > 0 && port < (1 << 16)
end
