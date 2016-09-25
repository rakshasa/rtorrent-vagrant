class client {

  package {
    ['screen']:
      ensure => installed,
      require => Exec['update-apt']
  }

  # @group { rtorrent: ensure=> present }
  # @user  { rtorrent: ensure=> present, gid => rtorrent }

  # realize Group[rtorrent]
  # realize User[rtorrent]

  file { '/home/vagrant/install-rtorrent.sh':
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755',
    source => 'puppet:///modules/client/install-rtorrent.sh',
  }

  file { '/home/vagrant/run-rtorrent.sh':
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755',
    source => 'puppet:///modules/client/run-rtorrent.sh',
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
    mode   => '0644',
    source => 'puppet:///modules/client/rtorrent.rc'
  }

  file { '/data/local/logs':
    ensure => directory,
    mode   => '0755'
  }

  file { '/data/local/logs/rtorrent':
    ensure => directory,
    mode   => '0755'
  }

  file { '/data/local/session':
    ensure => directory,
    mode   => '0755'
  }

  file { '/data/local/torrents':
    ensure => directory,
    mode   => '0755'
  }

}
