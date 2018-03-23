# ShellSkeleton

## Usage

This section explains how to use the project.

Run the main program.

```sh
bin/ss
```


## Development

This section explains how to improve the project.

Configure Git on Windows before cloning. This avoids problems with Vagrant and VirtualBox.

```sh
git config --global core.autocrlf input
```

Create the development virtual machine on Linux and Darwin.

```sh
script/vagrant/create.sh
```

Create the development virtual machine on Windows.

```bat
script\vagrant\create.bat
```

Run style check.

```sh
script/check.sh
```

Build project.

```sh
script/build.sh
```
