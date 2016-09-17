class baseconfig {

  group { 'puppet':
    ensure => 'present',
  }

  exec { 'update-apt':
    command => 'sudo apt-get update --fix-missing',
  }

  # TODO: Move dev packages to 'build' node.
  package {
    ['g++-4.8', 'automake', 'libtool', 'make', 'pkg-config', 'git-core', 'libcppunit-dev', 'libcurl4-openssl-dev', 'libncurses5-dev', 'libxmlrpc-core-c3-dev']:
      ensure => installed,
      require => Exec['update-apt']
  }

}
