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
    source => 'puppet:///modules/baseconfig/environment',
  }

  file { '/etc/ssh/sshd_config':
    ensure => file,
    source => 'puppet:///modules/baseconfig/sshd_config',
  }

  file { '/etc/pam.d/common-session':
    ensure => file,
    source => 'puppet:///modules/baseconfig/pam.common-session',
  }

  file { '/home/vagrant/.bashrc':
    ensure => file,
    owner => "vagrant",
    group => "vagrant",
    source => 'puppet:///modules/baseconfig/bashrc',
  }

  file { '/home/vagrant/.hushlogin':
    ensure => present,
    content => '',
  }
}
