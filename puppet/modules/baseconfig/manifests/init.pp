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

}
