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
    mode   => '0644',
    source => 'puppet:///modules/baseconfig/environment',
  }

  file { '/data/local/metadata':
    ensure => directory,
    mode   => '0755'
  }

  file { '/home/vagrant/update-metadata.sh':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/baseconfig/update-metadata.sh',
  }

}
