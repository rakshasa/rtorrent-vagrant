Exec {
  path => "/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin",
}

stage { 'pre':
  before => Stage['main']
}

class { 'baseconfig':
  stage => 'pre'
}

# node 'build' {
#   include foo
# }

# class test {

#   # class {
#   #   build: before => Class[clients];
#   #   clients:;
#   # }

# }

#include test
