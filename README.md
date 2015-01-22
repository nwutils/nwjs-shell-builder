nwjs shell builder
========================

nwjs shell builder for nwjs applications.

This script can be easily integrated into your release process.

It will download nwjs 32/64bit for Linux, Windows and OSX and build for all 3 platforms from given source directory

### Usage:

`$ ./nwjs-build --help`

```
The options are as follows:

        -h, --help
                Show help and usage

        -v, --version
                Show script version and exit

        --name=NAME
                Set package name

        --src=PATH
                Set package name

        --target="2 3"
                Build for particular OS or all (defaults to "0 1 2 3 4 5" - build for all)
                Available target:
                    0 - linux-ia32
                    1 - linux-x64
                    2 - win-ia32
                    3 - win-x64
                    4 - osx-ia32
                    5 - osx-x64

        --nw=VERSION
                Set nwjs version to use (defaults to 0.11.5)

        --otput-dir=PATH
                Change output directory

        --win-icon=PATH
                Path to .ico file

        --osx-icon=PATH
                Path to .icns file

        --osx-plist=PATH
                Path to .plist file

        --build
                Start the build process (IMPORTANT! Must be the last parameter of the command)

        --clean
                Clean and remove TMP directory
```


## EXAMPLES:

```

$ ./nwjs-build.sh
    --src=${HOME}/projects/${PKG_NAME}/src
    --otput-dir=${HOME}/${PKG_NAME}
    --name=${PKG_NAME}
    --build


$ ./nwjs-build.sh
    --src=${HOME}/projects/${PKG_NAME}/src
    --otput-dir=${HOME}/${PKG_NAME}
    --name=${PKG_NAME}
    --win-icon=${HOME}/projects/resorses/icon.ico
    --osx-icon=${HOME}/projects/resorses/icon.icns
    --osx-plist=${HOME}/projects/resorses/Info.plist
    --target="0 1 2 3 4 5"
    --build

```

#### Build only for windows 64 and 32 bit targets:


```

$ ./nwjs-build.sh
    --src=${HOME}/projects/${PKG_NAME}/src
    --otput-dir=${HOME}/${PKG_NAME}
    --name=${PKG_NAME}
    --win-icon=${HOME}/projects/resorses/icon.ico
    --target="2 3"
    --build

```

#### Build only for OSX 32 bit target:


```

$ ./nwjs-build.sh
    --src=${HOME}/projects/${PKG_NAME}/src
    --otput-dir=${HOME}/${PKG_NAME}
    --name=${PKG_NAME}
    --osx-icon=${HOME}/projects/resorses/icon.icns
    --osx-plist=${HOME}/projects/resorses/Info.plist
    --target="4"
    --build

```

#### Build only for all 64 bit

```

$ ./nwjs-build.sh
    --src=${HOME}/projects/${PKG_NAME}/src
    --otput-dir=${HOME}/${PKG_NAME}
    --name=${PKG_NAME}
    --osx-icon=${HOME}/projects/resorses/icon.icns
    --osx-plist=${HOME}/projects/resorses/Info.plist
    --win-icon=${HOME}/projects/resorses/icon.ico
    --target="1 3 5 "
    --build

```

### License 

[MIT](https://github.com/Gisto/nwjs-shell-builder/blob/master/LICENSE)