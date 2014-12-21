node-webkit shell builder
========================

Node-webkit shell builder for node-webkit applications.

This script can be easily integrated into your release process.

It will download node-webkit 32/64bit for Linux, Windows and OSX and build for all 3 platforms from given source directory

### Usage:

```
$ ./node-webkit-build --help
```

```
NAME

    Node-Webkit shell builder

SYNOPSIS

    node-webkit-build.sh [-h|--help] [-v|--version]
                      [--pkg-name=NAME] [--nw=VERSION] [--otput-dir=PATH]
                      [--win-icon=PATH] [--osx-icon=PATH] [--osx-plist=PATH]
                      [--build] [--clean]

DESCRIPTION

    Node-webkit bash builder for node-webkit applications.
    This script can be easily integrated into your release process.
    It will download node-webkit 32/64bit for Linux, Windows and OSX
    and build for all 3 platforms from given source directory

    Options can be set from within the script or via command line switches

    The options are as follows:

        -h, --help
                Show help and usage (You are looking at it)

        -v, --version
                Show script version and exit (Current version is: 1.0)

        --name=NAME
                Set package name (defaults to myapp)

        --src=PATH
                Set package name (defaults to ../../dist)

        --nw=VERSION
                Set node-webkit version to use (defaults to 0.11.3)

        --otput-dir=PATH
                Change output directory (defaults to /home/user/www/myapp/build/script/TMP/output)

        --win-icon=PATH
                Path to .ico file (defaults to ../../build/resources/windows/icon.ico)

        --osx-icon=PATH
                Path to .icns file (defaults to ../../build/resources/osx/myapp.icns)

        --osx-plist=PATH
                Path to .plist file (defaults to ../../build/resources/osx/Info.plist)

        --build
                Start the build process (IMPORTANT! Must be the last parameter of the command)

        --clean
                Clean and remove TMP directory

EXAMPLES:

    SHELL> ./node-webkit-build.sh
            --src=/home/user/projects/myapp/src
            --otput-dir=/home/user/myapp
            --name=myapp
            --build

    SHELL> ./node-webkit-build.sh
            --src=/home/user/projects/myapp/src
            --otput-dir=/home/user/myapp
            --name=myapp
            --win-icon=/home/user/projects/resorses/icon.ico
            --osx-icon=/home/user/projects/resorses/icon.icns
            --osx-plist=/home/user/projects/resorses/Info.plist
            --build
```
### License 

[MIT](https://github.com/Gisto/node-webkit-bash-builder/blob/master/LICENSE)