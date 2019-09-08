class builder {

  exec { 'add-llvm-key':
    command => 'wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -'
  } ~> Exec['update-apt']

  exec { 'add-llvm-repo':
    command => 'sudo add-apt-repository "deb http://apt.llvm.org/`lsb_release -sc`/ llvm-toolchain-`lsb_release -sc` main"',
  } ~> Exec['update-apt']

  exec { 'add-ubuntu-toolchain-r-test':
    command => 'sudo add-apt-repository ppa:ubuntu-toolchain-r/test',
  } ~> Exec['update-apt']

  exec { 'update-apt':
    command => 'sudo apt-get update --fix-missing',
  }

  package {
    ['g++-4.8', 'g++-4.9', 'clang-9',

     'automake', 'libtool', 'make', 'pkg-config', 'git-core',
     'libcppunit-dev',
     'libcurl4-openssl-dev', 'libncurses5-dev', 'libxmlrpc-core-c3-dev',
     'libowfat-dev', 'libudns-dev',

     'maradns',
     'mktorrent',
     'emacs24-nox',
     'swapspace',
     ]:
       ensure => installed,
       require => Exec['add-llvm-key', 'add-llvm-repo', 'add-ubuntu-toolchain-r-test', 'update-apt'],
  }

  @group { opentracker: ensure=> present }
  @user  { opentracker: ensure=> present, gid => opentracker }

  realize Group[opentracker]
  realize User[opentracker]

  file { '/etc/init.d/opentracker':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/builder/opentracker.init'
  }

  file { '/etc/maradns/mararc.default':
    ensure => file,
    require => Package['maradns'],
    source => 'puppet:///modules/builder/mararc.default'
  }

  file { '/etc/maradns/mararc.v4':
    ensure => file,
    require => Package['maradns'],
    source => 'puppet:///modules/builder/mararc.v4'
  }

  file { '/etc/maradns/mararc.if1v4':
    ensure => file,
    require => Package['maradns'],
    source => 'puppet:///modules/builder/mararc.if1v4'
  }

  file { '/etc/opentracker.conf':
    ensure => file,
    source => 'puppet:///modules/builder/opentracker.conf'
  }

  file {
    ['/data/local/log/tracker',
     ]:
    ensure => directory,
  }

  file {
    ['/data/shared/config',
     '/data/shared/maradns',
     '/data/shared/torrents',
     '/data/shared/watch',
     ]:
    ensure => directory,
    mode   => '0555',
  }

  file { '/data/shared/config/rtorrent.rc':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/builder/rtorrent.rc'
  }

  file { '/data/shared/maradns/db.rtorrent.if1v4':
    ensure => file,
    source => 'puppet:///modules/builder/db.rtorrent.if1v4'
  }

  file { '/data/shared/maradns/db.rtorrent.if1v6':
    ensure => file,
    source => 'puppet:///modules/builder/db.rtorrent.if1v6'
  }

  file { '/data/shared/maradns/db.rtorrent.if2v4':
    ensure => file,
    source => 'puppet:///modules/builder/db.rtorrent.if2v4'
  }

  file { '/data/shared/maradns/db.rtorrent.if2v6':
    ensure => file,
    source => 'puppet:///modules/builder/db.rtorrent.if2v6'
  }


}
