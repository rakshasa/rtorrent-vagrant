class baseconfig {

  group { 'puppet':
    ensure => 'present',
  }

  package {
    ['libncurses5', 'libxmlrpc-core-c3', 'libudns0',
     'lsb-release', 'screen', 'gdb',
     ]:
      ensure => installed
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
