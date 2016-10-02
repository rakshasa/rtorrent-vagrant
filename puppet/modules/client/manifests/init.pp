class client {

  package {
    []:
      ensure => installed,
      require => Exec['update-apt']
  }

  @group { rtorrent: ensure=> present }
  @user  { rtorrent: ensure=> present, gid => rtorrent }

  realize Group[rtorrent]
  realize User[rtorrent]

  file { '/home/vagrant/install-rtorrent':
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755',
    source => 'puppet:///modules/client/install-rtorrent',
  }

  file { '/home/vagrant/run-rtorrent':
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755',
    source => 'puppet:///modules/client/run-rtorrent',
  }

  file { '/etc/init.d/rtorrent':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/client/rtorrent.init'
  }

  file { '/etc/rtorrent.rc':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/client/rtorrent.rc'
  }

  file { '/data/local/logs/rtorrent':
    ensure => directory,
  }

  file { '/data/local/session':
    ensure => directory,
  }

  file { '/data/torrents':
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant',
  }

  file { '/home/vagrant/logs-rtorrent':
    ensure => link,
    target => '/data/local/logs/rtorrent'
  }

}
