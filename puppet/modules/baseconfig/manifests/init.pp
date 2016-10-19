class baseconfig {

  group { 'puppet':
    ensure => 'present',
  }

  exec { 'update-apt':
    command => 'sudo apt-get update --fix-missing',
  }

  package {
    ['libncurses5', 'libxmlrpc-core-c3',
     'screen', 'gdb'
     ]:
      ensure => installed,
      require => Exec['update-apt']
  }

  file { '/etc/environment':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/baseconfig/environment',
  }

  file { '/data/local/log':
    ensure => directory,
  }

  file { '/data/local/metadata':
    ensure => directory,
  }

  file { '/data/local/run':
    ensure => directory,
  }

  file { '/home/vagrant/metadata.source':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/metadata.source',
  }

  file { '/home/vagrant/update-metadata':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/update-metadata',
  }

  file { '/home/vagrant/enable-inet':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/enable-inet',
  }

  file { '/home/vagrant/disable-inet':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/disable-inet',
  }

  file { '/home/vagrant/change-inet6':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/change-inet6',
  }

}
