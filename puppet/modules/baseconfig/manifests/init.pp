class baseconfig {

  group { 'puppet':
    ensure => 'present',
  }

  exec { 'update-apt':
    command => 'sudo apt-get update --fix-missing',
  }

  package {
    ['libncurses5', 'libxmlrpc-core-c3']:
      ensure => installed,
      require => Exec['update-apt']
  }

  file { '/etc/environment':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/baseconfig/environment',
  }

  file { '/data/local/logs':
    ensure => directory,
  }

  file { '/data/local/metadata':
    ensure => directory,
  }

  file { '/home/vagrant/update-metadata.sh':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/update-metadata.sh',
  }

}
