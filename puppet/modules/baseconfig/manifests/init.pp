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

}
