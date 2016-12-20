# rtorrent-vagrant

Test environment for rtorrent using Vagrant.

# Stuff

While this environment primarily serves the needs of the main developer of rtorrent (me), that does not preclude contributions.

# Getting Started

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
