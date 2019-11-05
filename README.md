# ShellSkeleton

## Setup

Install project dependencies:

```sh
script/setup.sh
```


## Usage

Run the main program:

```sh
bin/ss
```

Run the main program inside the container:

```sh
docker run -it --rm funtimecoding/shell-skeleton
```


## Development

Configure Git on Windows before cloning:

```sh
git config --global core.autocrlf input
```

Install NFS plug-in for Vagrant on Windows:

```bat
vagrant plugin install vagrant-winnfsd
```

Create the development virtual machine on Linux and Darwin:

```sh
script/vagrant/create.sh
```

Create the development virtual machine on Windows:

```bat
script\vagrant\create.bat
```

Run style check and metrics:

```sh
script/check.sh [--help]
script/measure.sh [--help]
```

Build project:

```sh
script/build.sh
```

Install Debian package:

```sh
sudo dpkg --install build/shell-skeleton_0.1.0-1_all.deb
```

Show files the package installed:

```sh
dpkg-query --listfiles shell-skeleton
```
