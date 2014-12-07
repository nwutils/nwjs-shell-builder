node-webkit-bash-builder
========================

Node-webkit bash builder for node-webkit applications.

This script can be easily integrated into your release process.

It will download node-webkit 32/64bit for Linux, Windows and OSX and build for all 3 platforms from given source directory

### Usage:

Make proper configurations of paths in the file

Building: `$ ./node-webkit-build.sh --build` - this will build all platforms and output _.zip_ files in release directory (called _output_ by default)

Cleaning: `$ ./node-webkit-build.sh --clean` - this will clean everything script created to start the build proces over

### License 

[MIT](https://github.com/Gisto/node-webkit-bash-builder/blob/master/LICENSE)