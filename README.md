nwjs shell builder
========================

nwjs shell script builder for nwjs (node-webkit) applications.

This script can be easily integrated into your build process.
    
## How it works
    
It will download nwjs 32/64bit for Linux, Windows and OSX and build for all 3 platforms from given source directory

## How we use it

This script was made to help us automate nightly builds of [Gisto](http://wwwgistoapp.com)

You can see example usage in the CI script in Gisto repository: [drone.io script](https://github.com/Gisto/Gisto/blob/master/droneIO.sh)
    
### Usage:

`$ /path/to/nwjs-build.sh --help`

### Options:

| Option   |      Description |
|:----------|:----------------|
|`-h, --help`| Show help and usage |
|`--version=PACKAGE_VERSION`|Set package version (defaults to 1.0.0)|
|`--name=NAME`|Set package name (if not set - default will be used)|
|`--src=/PATH/TO/DIR`|Set path to source dir|
|`--target="2 3"`|Build for particular OS or all (default is to build for all targets) <br>Available targets: <br>- 0 - linux-ia32 <br>- 1 - linux-x64 <br>- 2 - win-ia32 <br>- 3 - win-x64 <br>- 4 - osx-ia32 <br>-  5 - osx-x64|
|`--nw=VERSION`|Set nwjs version to use (if not set - default will be used)|
|`--output-dir=/PATH/TO/DIR`|Change output directory (if not set - default will be used)|
| `--win-icon=/PATH/TO/FILE`|(For Windows target only) Path to .ico file (if not set - default will be used)|
|`--osx-icon=/PATH/TO/FILE`|(For OSX target only) Path to .icns file (if not set - default will be used)|
|`--CFBundleIdentifier=com.bundle.name`|(For OSX target only) Name of the [bundle’s Identifier](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/20001431-102070) (if not set - default will be used)|
|`--libudev`|(For Linux target only) Use if you want the script to handle the lack of _libudev.so.0_ (linux targets) as mentioned [here](https://github.com/nwjs/nw.js/wiki/The-solution-of-lacking-libudev.so.0)|
|`--build`|Start the build process (**IMPORTANT!** Must be the last parameter of the command)|
|`--clean`|Clean and remove TMP directory|

### EXAMPLES
========================

#### THE BARE MINIMUM TO BUILD:

    $ ./path/to/nwjs-build.sh \
        --src=/home/projects/PACKAGE_NAME/src \
        --build
        
#### CLEAN WORKING DIR:

    $ ./path/to/nwjs-build.sh \
        --clean

#### BUILD FOR ALL TARGETS:

    $ ./path/to/nwjs-build.sh \
        --src=/home/projects/PACKAGE_NAME/src \
        --output-dir=/path/to/output/the/builds \
        --name=PACKAGE_NAME \
        --win-icon=/home/projects/resorses/icon.ico \
        --osx-icon=/home/projects/resorses/icon.icns \
        --CFBundleExecutable=com.bundle.name \
        --target="0 1 2 3 4 5" \
        --version="1.0.0" \
        --libudev \
        --nw=0.11.6 \
        --build

#### BUILD ONLY FOR WINDOWS 64 AND 32 BIT TARGETS:

    $ ./path/to/nwjs-build.sh \
        --src=/home/projects/PACKAGE_NAME/src \
        --output-dir=/path/to/output/the/builds \
        --name=PACKAGE_NAME \
        --win-icon=/home/projects/resorses/icon.ico \
        --target="2 3" \
        --version="1.0.0" \
        --build

#### BUILD ONLY FOR OSX 32 BIT TARGET:

    $ ./path/to/nwjs-build.sh \
        --src=/home/projects/PACKAGE_NAME/src \
        --output-dir=/path/to/output/the/builds \
        --name=PACKAGE_NAME \
        --osx-icon=/home/projects/resorses/icon.icns \
        --CFBundleExecutable=com.bundle.name \
        --target="4" \
        --version="1.0.0" \
        --build

#### BUILD ONLY FOR ALL 64 BIT

    $ ./path/to/nwjs-build.sh \
        --src=/home/projects/PACKAGE_NAME/src \
        --output-dir=/path/to/output/the/builds \
        --name=PACKAGE_NAME \
        --osx-icon=/home/projects/resorses/icon.icns \
        --win-icon=/home/projects/resorses/icon.ico \
        --CFBundleExecutable=com.bundle.name \
        --target="1 3 5 " \
        --version="1.0.0" \
        --libudev \
        --build
### License 

[MIT](https://github.com/Gisto/nwjs-shell-builder/blob/master/LICENSE)
