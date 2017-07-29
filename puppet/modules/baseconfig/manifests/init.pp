class baseconfig {

  group { 'puppet':
    ensure => 'present',
  }

  exec { 'update-apt':
    command => 'sudo apt-get update --fix-missing',
  }

  exec { 'add-ubuntu-toolchain-r-test':
    command => 'sudo add-apt-repository ppa:ubuntu-toolchain-r/test',
  }

  package {
    ['libncurses5', 'libxmlrpc-core-c3',
     'screen', 'gdb'
     ]:
      ensure => installed,
      require => Exec['add-ubuntu-toolchain-r-test', 'update-apt']
  }

  $data_dirs = ['/data/local/log',
                '/data/local/metadata',
                '/data/local/run']

  file {
    [$data_dirs,
     '/usr/local/bin/'
     ]:
    ensure => directory,
  }

  file { '/etc/environment':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/baseconfig/environment',
  }

  file { '/usr/local/bin/metadata.source':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/metadata.source',
  }

  file { '/usr/local/bin/update-metadata':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/update-metadata',
  }

  file { '/usr/local/bin/enable-ipv4':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/enable-ipv4',
  }

  file { '/usr/local/bin/enable-ipv6':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/enable-ipv6',
  }

  file { '/usr/local/bin/disable-ipv4':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/disable-ipv4',
  }

  file { '/usr/local/bin/disable-ipv6':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/disable-ipv6',
  }

  file { '/usr/local/bin/change-ipv4':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/change-ipv4',
  }

  file { '/usr/local/bin/change-ipv6':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/change-ipv6',
  }

}
