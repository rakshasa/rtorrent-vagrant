Exec {
  path => "/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin",
}

stage { 'pre':
  before => Stage['main']
}

class { 'baseconfig':
  stage => 'pre'
}

node 'default' {
  include client
}

# node 'builder' {
#   include builder
# }

# if $hostname == 'builder' {
#   include builder
# }

node 'builder.example.com' {
  include builder
}
