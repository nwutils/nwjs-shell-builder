nwjs shell builder
========================

nwjs shell script builder for nwjs (node-webkit) applications.

This script can be easily integrated into your build process.
    
### How it works
    
It will download nwjs 32/64bit for Linux, Windows and OSX and build for all 3 platforms from given source directory

### How we use it

This script was made to help us automate nightly builds of [Gisto](http://wwwgistoapp.com)

You can see example usage in the CI script in Gisto repository: [drone.io script](https://github.com/Gisto/Gisto/blob/master/droneIO.sh) 
    
### Usage:

`$ ./nwjs-build --help`

```
The options are as follows:

        -h, --help
                Show help and usage (You are looking at it)

        -v, --version
                Show script version and exit (Current version is: 1.0.2)

        --name=NAME
                Set package name (defaults to myapp)

        --src=PATH
                Set path to source dir

        --target="2 3"
                Build for particular OS or all (defaults to 0 1 2 3 4 5)
                Available target:
                    0 - linux-ia32
                    1 - linux-x64
                    2 - win-ia32
                    3 - win-x64
                    4 - osx-ia32
                    5 - osx-x64

        --nw=VERSION
                Set nwjs version to use (defaults to 0.11.6)

        --otput-dir=PATH
                Change output directory

        --win-icon=PATH
                Path to .ico file

        --osx-icon=PATH
                Path to .icns file

        --libudev
                Use if you want the script to hanle the lack of libudev (linux targets)
                As mentioned here:
                    https://github.com/nwjs/nw.js/wiki/The-solution-of-lacking-libudev.so.0

        --osx-plist=PATH
                Path to .plist file

        --build
                Start the build process (IMPORTANT! Must be the last parameter of the command)

        --clean
                Clean and remove TMP directory
                
```


## EXAMPLES:

```

$ ./nwjs-build.sh \
    --src=/home/sasha/projects/myapp/src \
    --otput-dir=/home/sasha/myapp \
    --name=myapp \
    --target="1 3 5 " \
    --build

$ ./nwjs-build.sh \
    --src=/home/sasha/projects/myapp/src \
    --otput-dir=/home/sasha/myapp \
    --name=myapp \
    --win-icon=/home/sasha/projects/resorses/icon.ico \
    --osx-icon=/home/sasha/projects/resorses/icon.icns \
    --osx-plist=/home/sasha/projects/resorses/Info.plist \
    --target="0 1 2 3 4 5" \
    --libudev \
    --build


```

#### Build only for windows 64 and 32 bit:


```

$ ./nwjs-build.sh \
    --src=/home/sasha/projects/myapp/src \
    --otput-dir=/home/sasha/myapp \
    --name=myapp \
    --win-icon=/home/sasha/projects/resorses/icon.ico \
    --target="2 3" \
    --build

```

#### Build only for OSX 32 bit:


```

$ ./nwjs-build.sh \
    --src=/home/sasha/projects/myapp/src \
    --otput-dir=/home/sasha/myapp \
    --name=myapp \
    --osx-icon=/home/sasha/projects/resorses/icon.icns \
    --osx-plist=/home/sasha/projects/resorses/Info.plist \
    --target="4" \
    --build

```

#### Build only 64 bit, all platform

```

$ ./nwjs-build.sh \
    --src=/home/sasha/projects/myapp/src \
    --otput-dir=/home/sasha/myapp \
    --name=myapp \
    --osx-icon=/home/sasha/projects/resorses/icon.icns \
    --osx-plist=/home/sasha/projects/resorses/Info.plist \
    --win-icon=/home/sasha/projects/resorses/icon.ico \
    --target="1 3 5 " \
    --libudev \
    --build

```

### License 

[MIT](https://github.com/Gisto/nwjs-shell-builder/blob/master/LICENSE)