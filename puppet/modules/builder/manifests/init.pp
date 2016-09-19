class builder {

  package {
    ['g++-4.8', 'automake', 'libtool', 'make', 'pkg-config', 'git-core', 'libcppunit-dev', 'libcurl4-openssl-dev', 'libncurses5-dev', 'libxmlrpc-core-c3-dev']:
      ensure => installed,
      require => Exec['update-apt']
  }

  file { '/home/vagrant/build-rtorrent.sh':
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755',
    source => 'puppet:///modules/builder/build-rtorrent.sh',
  }

}
