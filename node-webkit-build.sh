#!/bin/bash
######################################################################
# node-weblit shell build script                                     #
######################################################################
# For usage see: ./node-webkit-build.sh --help                       #
######################################################################

SCRIPT_VER='1.0'

THIS_SCRIPT="`readlink -e $0`"

# Current working directory
WORKING_DIR="`dirname $THIS_SCRIPT`"

# LOCAL mode is usefull when:
#   * You're testing the script and you don't want to download NW archives every time
#   * You have the archives localy
# default is "FALSE"
LOCAL_NW_ARCHIVES_MODE=1
LOCAL_NW_ARCHIVES_PATH="/backup/Gisto/nw"

# Wanted node-webkit version
NW_VERSION='0.11.3';

# Base domain for node-webkit download server
DL_URL="http://dl.node-webkit.org"

# Temporary directory where all happens (relative to current directory where this script running from)
# This directory will be auto created
TMP="TMP"

# Sorces directory path
PKG_SRC="../../dist"

# Final output directory (relative to current directory where this script running from)
RELEASE_DIR="${WORKING_DIR}/${TMP}/output"

# Icons and other resources
OSX_RESOURCE_PLIST="../../build/resources/osx/Info.plist"
OSX_RESOURCE_ICNS="../../build/resources/osx/gisto.icns"
WIN_RESOURCE_ICO="../../build/resources/windows/icon.ico"

# Date on the package archive as PkgName-YYYYMMDD-OS-architecture.zip
DATE=$(date +"%Y%m%d")

# Name of your package
PKG_NAME="myapp"

# --------------------------------------------------------------------
# Guess you should not need to edit bellow this comment block
# Unless you really want/need to
# --------------------------------------------------------------------

ARR_OS[0]="linux-ia32"
ARR_OS[1]="linux-x64"
ARR_OS[2]="win-ia32"
ARR_OS[3]="win-x64"
ARR_OS[4]="osx-ia32"
ARR_OS[5]="osx-x64"

ARR_DL_EXT[0]="tar.gz"
ARR_DL_EXT[1]="tar.gz"
ARR_DL_EXT[2]="zip"
ARR_DL_EXT[3]="zip"
ARR_DL_EXT[4]="zip"
ARR_DL_EXT[5]="zip"

ARR_EXTRACT_COMMAND[0]="tar"
ARR_EXTRACT_COMMAND[1]="tar"
ARR_EXTRACT_COMMAND[2]="zip"
ARR_EXTRACT_COMMAND[3]="zip"
ARR_EXTRACT_COMMAND[4]="zip"
ARR_EXTRACT_COMMAND[5]="zip"

TXT_BOLD="\e[1m"
TXT_NORMAL="\e[1m"
TXT_RED="\e[31m"
TXT_BLUE="\e[34m"
TXT_GREEN="\e[32m"
TXT_YELLO="\e[93m"
TXT_RESET="\e[0m"
TXT_NOTE="\e[30;48;5;82m"

usage() {
clear && cat <<EOF

NAME

    Node-Webkit shell builder

SYNOPSIS

    node-webkit-build.sh [-h|--help] [-v|--version]
                      [--pkg-name=NAME] [--nw=VERSION] [--otput-dir=/FULL/PATH]
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
                Show script version and exit (Current version is: ${SCRIPT_VER})

        --name=NAME
                Set package name (defaults to ${PKG_NAME})

        --src=PATH
                Set package name (defaults to ${PKG_SRC})

        --nw=VERSION
                Set node-webkit version to use (defaults to ${NW_VERSION})

        --otput-dir=PATH
                Change output directory (defaults to ${RELEASE_DIR})

        --win-icon=PATH
                Path to .ico file (defaults to ${WIN_RESOURCE_ICO})

        --osx-icon=PATH
                Path to .icns file (defaults to ${OSX_RESOURCE_ICNS})

        --osx-plist=PATH
                Path to .plist file (defaults to ${OSX_RESOURCE_PLIST})

        --build
                Start the build process (IMPORTANT! Must be the last parameter of the command)

        --clean
                Clean and remove ${TMP} directory

EXAMPLES:

    SHELL> ./node-webkit-build.sh
            --src=${HOME}/projects/${PKG_NAME}/src
            --otput-dir=${HOME}/${PKG_NAME}
            --name=${PKG_NAME}
            --build

    SHELL> ./node-webkit-build.sh
            --src=${HOME}/projects/${PKG_NAME}/src
            --otput-dir=${HOME}/${PKG_NAME}
            --name=${PKG_NAME}
            --win-icon=${HOME}/projects/resorses/icon.ico
            --osx-icon=${HOME}/projects/resorses/icon.icns
            --osx-plist=${HOME}/projects/resorses/Info.plist
            --build

EOF
}

NOTE () {
    printf "\n";
    printf "${TXT_NOTE} ${1} ${TXT_RESET} "
    printf "\n";
}

clean(){
    rm -rf ${WORKING_DIR}/${TMP};
    NOTE "Removed \"${WORKING_DIR}/${TMP}\" directory and it's content";
}

extractme() {
    if [[ ${1} = "zip" ]]; then
        unzip -qq ${2} -d ${3};
    else
        tar xzf ${2} -C ${3};
    fi
}

split_string() {
	#USAGE: `split_string $string ,` - the comma here is the separator. Also see `man cut`
	echo "$1" | cut -d"$2" -f1;
}

make_bins() {
    mkdir -p ${RELEASE_DIR}
    local make_os=`split_string "${1}" "-"`;
    if [[ ${make_os} = "linux" ]]; then
        cat ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/nw ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw > ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}
        rm ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw
        chmod +x ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}
        cp ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/{icudtl.dat,nw.pak} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/
        cd ${WORKING_DIR}/${TMP}/${1}/latest-git
        zip -qq -r ${PKG_NAME}-${DATE}-${1}.zip *;
        mv ${PKG_NAME}-${DATE}-${1}.zip ${RELEASE_DIR};
        cd ${WORKING_DIR};
    fi
    if [[ ${make_os} = "win" ]]; then
        cat ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/nw.exe ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw > ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.exe
        rm ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw
        cp ${WIN_RESOURCE_ICO} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/{icudtl.dat,nw.pak,libEGL.dll,libGLESv2.dll,d3dcompiler_46.dll} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/
        cd ${WORKING_DIR}/${TMP}/${1}/latest-git
        zip -qq -r ${PKG_NAME}-${DATE}-${1}.zip *;
        mv ${PKG_NAME}-${DATE}-${1}.zip ${RELEASE_DIR};
        cd ${WORKING_DIR};
    fi
    if [[ ${make_os} = "osx" ]]; then
        cp -r ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/node-webkit.app ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.app;
        cp -r ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.app/Contents/Resources/app.nw;
        rm -r ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw
        cp -r ${OSX_RESOURCE_ICNS} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.app/Contents/Resources/
        cp -r ${OSX_RESOURCE_PLIST} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.app/Contents
        cd ${WORKING_DIR}/${TMP}/${1}/latest-git
        zip -qq -r ${PKG_NAME}-${DATE}-${1}.zip *;
        mv ${PKG_NAME}-${DATE}-${1}.zip ${RELEASE_DIR};
        cd ${WORKING_DIR};
    fi
}

build() {
    for i in $(seq 0 5); do
        mkdir -p ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git;
        local DL_FILE="${WORKING_DIR}/${TMP}/node-webkit-v${NW_VERSION}-${ARR_OS[$i]}.${ARR_DL_EXT[$i]}";
        if [[ ! -f ${DL_FILE} ]]; then
            NOTE 'WORKING';
            printf "Bulding ${TXT_BOLD}${TXT_YELLO}${PKG_NAME}${TXT_RESET} for ${TXT_BOLD}${TXT_YELLO}${ARR_OS[$i]}${TXT_RESET}\n"
            if [[ ${LOCAL_NW_ARCHIVES_MODE} = "TRUE" || ${LOCAL_NW_ARCHIVES_MODE} = "true" || ${LOCAL_NW_ARCHIVES_MODE} = "1" ]]; then
                cp ${LOCAL_NW_ARCHIVES_PATH}/node-webkit-v${NW_VERSION}-${ARR_OS[$i]}.${ARR_DL_EXT[$i]} ${WORKING_DIR}/${TMP};
            else
                wget -P ${WORKING_DIR}/${TMP} ${DL_URL}/v${NW_VERSION}/node-webkit-v${NW_VERSION}-${ARR_OS[$i]}.${ARR_DL_EXT[$i]};
            fi
            extractme "${ARR_EXTRACT_COMMAND[$i]}" "${DL_FILE}" "${WORKING_DIR}/${TMP}/${ARR_OS[$i]}";
            mv ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit-v${NW_VERSION}-${ARR_OS[$i]} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit;

            if [[ `split_string "${ARR_OS[$i]}" "-"` = "osx" ]]; then
                cp -r ${PKG_SRC} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw;
            else
                cd ${PKG_SRC};
                zip -qq -r ${PKG_NAME}.zip *;
                mv ${PKG_NAME}.zip ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw;
                cd ${WORKING_DIR};
            fi
            # Build binaries
            make_bins "${ARR_OS[$i]}";
        else
            NOTE 'NOTE';
            printf "File ${TXT_BOLD}${TXT_YELLO}${DL_FILE}${TXT_RESET} exists.";
        fi
    done
    NOTE "DONE";
    printf "You will find your '${PKG_NAME}' builds in '${RELEASE_DIR}' directory\n";
}

### Arguments
while true; do
  case $1 in
    -h | --help )
        usage;
        exit 0
        ;;
    -V | -v | --version )
        printf '%s\n' "Version: ${SCRIPT_VER}";
        exit 0
        ;;
    --nw=* )
        NW_VERSION="${1#*=}";
        shift
        ;;
    --name=* )
        PKG_NAME="${1#*=}";
        shift
        ;;
    --otput-dir=* )
        RELEASE_DIR="${1#*=}";
        shift
        ;;
    --src=* )
        PKG_SRC="${1#*=}"
        shift
        ;;
    --osx-icon=* )
        OSX_RESOURCE_ICNS="${1#*=}"
        shift
        ;;
    --osx-plist=* )
        OSX_RESOURCE_PLIST="${1#*=}"
        shift
        ;;
    --win-icon=* )
        WIN_RESOURCE_ICO="${1#*=}"
        shift
        ;;
    --clean )
        clean;
        exit 0
        ;;
    --build )
        build;
        exit 0
        ;;
    -- )
        shift;
        break
        ;;
    -* )
        printf 'Hmmm, unknown option: "%s".\n' "${1}";
        exit 0
        ;;
    * )
        usage;
        break
        ;;
  esac
done