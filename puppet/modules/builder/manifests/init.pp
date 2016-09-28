class builder {

  package {
    ['g++-4.8', 'automake', 'libtool', 'make', 'pkg-config', 'git-core',
     'libcppunit-dev', 'libcurl4-openssl-dev', 'libncurses5-dev', 'libxmlrpc-core-c3-dev',
     'libowfat-dev'
     ]:
      ensure => installed,
      require => Exec['update-apt']
  }

  @group { opentracker: ensure=> present }
  @user  { opentracker: ensure=> present, gid => opentracker }

  realize Group[opentracker]
  realize User[opentracker]

  file { '/home/vagrant/build-rtorrent.sh':
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755',
    source => 'puppet:///modules/builder/build-rtorrent.sh'
  }

  file { '/home/vagrant/build-tracker.sh':
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755',
    source => 'puppet:///modules/builder/build-tracker.sh'
  }

  file { '/home/vagrant/run-tracker.sh':
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755',
    source => 'puppet:///modules/builder/run-tracker.sh'
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

  file { '/data/local/logs/tracker':
    ensure => directory,
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
