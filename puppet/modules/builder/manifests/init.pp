class builder {

  package {
    ['g++-4.8', 'g++-4.9',
     'automake', 'libtool', 'make', 'pkg-config', 'git-core',
     'libcppunit-dev',
     'libcurl4-openssl-dev', 'libncurses5-dev', 'libxmlrpc-core-c3-dev',
     'libowfat-dev',

     'mktorrent', 'emacs24-nox',
     'swapspace'
     ]:
      ensure => installed,
      require => Exec['update-apt']
  }

  @group { opentracker: ensure=> present }
  @user  { opentracker: ensure=> present, gid => opentracker }

  realize Group[opentracker]
  realize User[opentracker]

  file { '/etc/init.d/opentracker':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/builder/opentracker.init'
  }

  file { '/etc/opentracker.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/builder/opentracker.conf'
  }

  file { '/data/local/log/tracker':
    ensure => directory,
  }

  file { '/data/shared/config':
    ensure => directory,
    mode   => '0555',
  }

  file { '/data/shared/config/rtorrent.rc':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/builder/rtorrent.rc'
  }

  file { '/data/shared/torrents':
    ensure => directory,
    mode   => '0555',
  }

  file { '/data/shared/watch':
    ensure => directory,
    mode   => '0555',
  }

}
