# LXD Debian Package

> 🛈 &nbsp; https://launchpad.net/~randombenj/+archive/ubuntu/lxd
>
> ```sh
> sudo add-apt-repository ppa:randombenj/lxd
> sudo apt update
> sudo apt install lxd
> ```


Due to so many issues using snap, that made lxd nearly unusable for us
we decided to package lxd as a debian package, inspired by: https://salsa.debian.org/mjeanson/lxd

The package is locally built, [following the official build instructions](https://linuxcontainers.org/lxd/docs/master/installing/).
This is mainly to avoid having to deal with outdated golang versions on the
system.

The following packages are built:

- `lxd`: Contains the lxd daemon (depends on all the other packages)
- `lxd-client`: Contains the `lxc` client command
- `lxd-agent`: Optional lxd-agent used inside the virtual machines
- `libdqlite0`: Used internally by lxd
- `libraft2`: Used by `libdqlite0`
