# -*- mode: ruby -*-

def configure_networks(node, config)
  # The VirtualBox host-only network should have a private IPv6
  # subnet in 'fc00::/7', e.g. 'fdcc::/16'.
  node.vm.network 'private_network', type: 'dhcp'
  #node.vm.network 'private_network', type: 'static', ip: "fddd::#{config[:ipv6]}/16"

  config[:forward] && config[:forward].each { |params| # Replace with named args.
    forward_port(node, params)
  }
  
  node.trigger.after :up do
    if !enable_ipv4?(config)
      run_remote 'disable-ipv4'
    end

    if enable_ipv6?(config)
      run_remote "change-ipv6 fdcc::#{config[:ipv6]}/16"
    else
      run_remote 'disable-ipv6'
    end
  end
end

def enable_ipv4?(config)
  !config.has_key?(:enable_ipv4) || config[:enable_ipv4]
end

def enable_ipv6?(config)
  config[:ipv6]
end

def valid_port?(port, allow_nil: false)
  if port
    port > 0 && port < (1 << 16)
  else
    allow_nil
  end
end

def forward_port(node, params)
  if !valid_port?(params[:guest]) || !valid_port?(params[:host])
    raise Vagrant::Errors::ConfigInvalid.new
  end

  node.vm.network 'forwarded_port', guest: params[:guest], host: params[:host]

  node.trigger.after :up do
    run_remote "echo #{params[:host]} > /data/local/metadata/forward.#{params[:guest]}"
  end
end
