# -*- mode: ruby -*-

def configure_networks(node, config)
  # The VirtualBox host-only network should have a private IPv6
  # subnet in 'fd00::/7', e.g. 'fdcc::/16'.

  config[:interfaces] && config[:interfaces].each_with_index { |interface, nw_index|
    interface[:network].nil? && (raise Vagrant::Errors::ConfigInvalid.new)
    interface[:ipv4].nil? && (raise Vagrant::Errors::ConfigInvalid.new)
    interface[:ipv6].nil? && (raise Vagrant::Errors::ConfigInvalid.new)

    node.vm.network 'private_network', type: 'static', ip: private_network_ip(interface), virtualbox__intnet: interface[:network]

    node.trigger.after :up do
      if enable_ipv4?(interface)
        run_remote "change-ipv4-#{nw_index + 1} #{interface[:ipv4]}/24"
      else
        run_remote "disable-ipv4-#{nw_index + 1}"
      end

      if enable_ipv6?(interface)
        run_remote "change-ipv6-#{nw_index + 1} #{interface[:ipv6]}/16"
      else
        run_remote "disable-ipv6-#{nw_index + 1}"
      end
    end
  }

  config[:forward] && config[:forward].each { |params| # Replace with named args.
    forward_port(node, params)
  }
end

def enable_ipv4?(interface)
  interface[:ipv4]
end

def enable_ipv6?(interface)
  interface[:ipv6]
end

def private_network_ip(interface)
  case
  when enable_ipv4?(interface)
    return interface[:ipv4]
  when enable_ipv6?(interface)
    return interface[:ipv6]
  else
    raise Vagrant::Errors::ConfigInvalid.new
  end
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

  # TODO: Bind to NAT interface.
  guest_ip = nil

  node.vm.network 'forwarded_port', guest: params[:guest], guest_ip: guest_ip, host: params[:host]

  node.trigger.after :up do
    run_remote "echo #{params[:host]} > /data/local/metadata/forward.#{params[:guest]}"
  end
end
