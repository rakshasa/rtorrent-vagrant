rtorrent-vagrant
================

Test environment for rtorrent using Vagrant.


Stuff
-----

While this environment primarily serves the needs of the main developer of rtorrent (me), that does not preclude contributions.


Getting Started
---------------

```
make setup      - install required vagrant plugins
make init       - initialize vms and build rtorrent (support BRANCH, or LIBTORRENT_BRANCH and RTORRENT_BRANCH variables)
make rebuild    - rebuild libtorrent and rtorrent
make check      - rebuild libtorrent and rtorrent with unittests
make test_http4 - creates torrent and attempts to seed it
```

Example:

```
make setup && RTORRENT_BRANCH=feature-foo make init && make test_http4
```


Testing
-------

Test all:

```
./scripts/test-all
```


Blocked ports
-------------

```
eth1 ipv4 blocks 15000-15499
eth2 ipv4 blocks 15500-15999
eth1 ipv6 blocks 16000-16499
eth2 ipv6 blocks 16500-16999
```


Cygwin issues
-------------

Including emacs's bin directory in PATH may causes issues.