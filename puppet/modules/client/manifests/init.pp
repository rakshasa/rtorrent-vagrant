class client {

  file { '/home/vagrant/install-rtorrent.sh':
    ensure => file,
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0755',
    source => 'puppet:///modules/client/install-rtorrent.sh',
  }

}
