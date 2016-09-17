Exec {
  path => "/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin",
}

class dev {

  class {
    init:;
    # init: before => Class[ltp];
    # ltp:;
  }

}

class init {

  group { 'puppet':
    ensure => 'present',
  }

  # Let's update the system
  exec { 'update-apt':
    command => 'sudo apt-get update',
  }

  # Let's install the dependecies
  package {
    ['g++-4.8', 'automake', 'libtool', 'make', 'pkg-config', 'git-core', 'libcppunit-dev', 'libcurl4-openssl-dev', 'libncurses5-dev', 'libxmlrpc-core-c3-dev']:
      ensure => installed
      # require => Exec['update-apt'] # The system update needs to run first
  }

  # Let's install the project dependecies from pip
  # exec { 'pip-install-requirements':
  #   command => "sudo /usr/bin/pip install -r $PROJ_DIR/requirements.txt",
  #   tries => 2,
  #   timeout => 600, # Too long, but this can take awhile
  #   require => Package['python-pip', 'python-dev'], # The package dependecies needs to run first
  #   logoutput => on_failure,
  # }

}

include dev
