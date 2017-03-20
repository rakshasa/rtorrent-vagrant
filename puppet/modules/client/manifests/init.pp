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

  $data_dirs = ['/data/local/config',
                '/data/local/log',
                '/data/local/log/old',
                '/data/local/session',
                '/data/torrents']

  file { $data_dirs:
    ensure => directory,
    owner  => 'vagrant',
    group  => 'vagrant'
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

  file { '/usr/local/bin/start-rtorrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/client/start-rtorrent'
  }

  file { '/usr/local/bin/stop-rtorrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/client/stop-rtorrent'
  }

  file { '/usr/local/bin/kill-rtorrent':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/client/kill-rtorrent'
  }

  file { '/usr/local/bin/torrent-status':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/client/torrent-status'
  }

}
