#!/bin/sh -e

mkdir -p build/root-directory

mkdir -p build/root-directory/usr/bin
cp bin/other.sh build/root-directory/usr/bin

mkdir -p build/root-directory/debian
echo "Package: shell-skeleton
Version: 0.0.1-1
Architecture: all
Maintainer: Alexander Reitzel <alexander.reitzel@gmail.com>
Depends: python
Description: simple example package
 Very simple example package using dpkg-deb.
 The python dependency is just to explain how to add dependencies." > build/root-directory/debian/control

dpkg-deb --build build/root-directory build/shell-skeleton_0.0.1_all.deb
