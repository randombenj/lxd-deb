> :warning:&nbsp;&nbsp;**THIS REPO IS NO LONGER MAINTAINED**

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

The dependencies are installed using [vendoring](https://go.dev/ref/mod#vendoring) and uploaded as a source package to ubuntu ppa.
This is mainly to avoid having to deal with outdated golang versions on ubuntu.

The following packages are built:

- `lxd`: Contains the lxd daemon (depends on all the other packages)
- `lxd-client`: Contains the `lxc` client command
- `lxd-agent`: Optional lxd-agent used inside the virtual machines
- `libdqlite0`: Used internally by lxd
- `libraft2`: Used by `libdqlite0`
