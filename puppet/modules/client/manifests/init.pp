class client {

  package {
    ['iptables-persistent']:
      ensure => installed,
      require => Exec['update-apt']
  }

  exec { 'iptables-persistent':
    command => 'sudo service iptables-persistent restart',
  }

  @group { rtorrent: ensure=> present }
  @user  { rtorrent: ensure=> present, gid => rtorrent }

  realize Group[rtorrent]
  realize User[rtorrent]

  $data_dirs = ['/data/local/config',
                '/data/local/log/old',
                '/data/local/session',
                '/data/torrents']

  file { $data_dirs:
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant'
  }

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/iptables':
    ensure => directory
  }

  file { '/etc/iptables/rules.v4':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/client/rules.v4'
  }

  file { '/etc/iptables/rules.v6':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/client/rules.v6'
  }

}
