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

  file { '/data/local/log/rtorrent':
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

  file { '/home/vagrant/log-rtorrent':
    ensure => link,
    target => '/data/local/log/rtorrent'
  }

  file { '/home/vagrant/run-rtorrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/client/run-rtorrent'
  }

  file { '/home/vagrant/stop-rtorrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/client/stop-rtorrent'
  }

}
