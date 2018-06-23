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

  file { '/usr/local/bin/build-rtorrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/builder/build-rtorrent'
  }

  file { '/usr/local/bin/check-libtorrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/builder/check-libtorrent'
  }

  file { '/usr/local/bin/check-rtorrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/builder/check-rtorrent'
  }

  file { '/usr/local/bin/rebuild-rtorrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/builder/rebuild-rtorrent'
  }

  file { '/usr/local/bin/build-tracker':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/builder/build-tracker'
  }

  file { '/usr/local/bin/make-torrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/builder/make-torrent'
  }

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

  file { '/data/shared/torrents':
    ensure => directory,
    mode   => '0555',
  }

  file { '/data/shared/watch':
    ensure => directory,
    mode   => '0555',
  }

}
