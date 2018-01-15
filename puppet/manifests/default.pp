Exec {
  path => "/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin",
}

stage { 'pre':
  before => Stage['main']
}

class { 'baseconfig':
  stage => 'pre'
}

node /^builder\./ {
  include builder
}

node /^node\d+\./ {
  include client
}

node /^node-dl\./ {
  include client
}
