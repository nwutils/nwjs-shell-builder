#!/bin/bash
######################################################################
# node-weblit bash build script                                      #
######################################################################

# --------------------------------------------------------------------
# Usage
# --------------------------------------------------------------------
# Building: $ ./node-webkit-build.sh --build
# Cleaning: $ ./node-webkit-build.sh --clean
# --------------------------------------------------------------------

# Debug mode is usefull when testing the script and you don't want to
# download NW archives every time, instead, they are copied from
# DEBUG_MODE_ARCHIVES directory.
# Set to "FALSE" for production
DEBUG="FALSE"
DEBUG_MODE_ARCHIVES="/path/to/local/node-webkit/archives"

# Current working directory
WORKING_DIR=`pwd`

# Wanted node-webkit version
NW_VERSION='0.11.2';

# Base domain for node-webkit download server
DL_URL="http://dl.node-webkit.org"

# Sorces directory (relative to current directory where this script running from)
PKG_SRC="../dist"

# Final output directory (relative to current directory where this script running from)
RELEASE_DIR="output"

# OSX "icns" and "plist" directory (relative to current directory where this script running from)
OSX_RESOURCE="../build/osx"

# Temporary directory where all happens (relative to current directory where this script running from)
# This directory will be auto created
TMP="TMP"

# Date on the package archive as PkgName-YYYYMMDD-OS-architecture.zip
DATE=$(date +"%Y%m%d")

# Name of your package
PKG_NAME="gisto"

# Name of the package archive as PkgName-YYYYMMDD-OS-architecture.zip
# OS and architecture is set by the script respectevely
PKG_ARCHIVE_NAME="${PKG_NAME}-git-${DATE}"

# --------------------------------------------------------------------
# Guess you should not need to edit bellow this comment block
# Unless you really want to
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
TXT_RED="\e[31m"
TXT_BLUE="\e[34m"
TXT_GREEN="\e[32m"
TXT_YELLO="\e[93m"
TXT_RESET="\e[0m"
TXT_NOTE="\e[30;48;5;82m"

usage() {
    printf "\n--- ${TXT_YELLO}NODE-WEBKIT-BUILD-BASH${TXT_RESET} ------------------------------\n\n"
    printf "\tNode-weblit bash build script\n\tUse to build node-webkit apps from command line\n"
    printf "\n--- ${TXT_YELLO}USAGE${TXT_RESET} -----------------------------------------------\n\n"
    printf "\tBuilding: \n\t${TXT_GREEN}\$${TXT_RESET} ${TXT_BLUE}./node-webkit-build.sh --build${TXT_RESET}\n"
    printf "\tCleaning: \n\t${TXT_GREEN}\$${TXT_RESET} ${TXT_BLUE}./node-webkit-build.sh --clean${TXT_RESET}\n"
    printf "\tHelp: \n\t${TXT_GREEN}\$${TXT_RESET} ${TXT_BLUE}./node-webkit-build.sh --help${TXT_RESET}"
    printf "\n---------------------------------------------------------\n"
}

NOTE () {
    printf "${TXT_NOTE} ${1} ${TXT_RESET} "
}

clean(){
    rm -rf ${WORKING_DIR}/${TMP};
    printf "Clean\n";
}

update() {
    printf "Update\n";
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
    mkdir -p ${WORKING_DIR}/${TMP}/${RELEASE_DIR}
    make_os=`split_string "${1}" "-"`;
    if [[ ${make_os} = "linux" ]]; then
        cat ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/nw ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw > ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}
        rm ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw
        chmod +x ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}
        cp ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/{icudtl.dat,nw.pak} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/
        cd ${WORKING_DIR}/${TMP}/${1}/latest-git
        zip -qq -r ${PKG_ARCHIVE_NAME}-${1}.zip *;
        mv ${PKG_ARCHIVE_NAME}-${1}.zip ${WORKING_DIR}/${TMP}/${RELEASE_DIR};
        cd ${WORKING_DIR};
    fi
    if [[ ${make_os} = "win" ]]; then
        cat ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/nw.exe ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw > ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.exe
        rm ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw
        cp ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/{icudtl.dat,nw.pak,libEGL.dll,libGLESv2.dll,d3dcompiler_46.dll} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/
        cd ${WORKING_DIR}/${TMP}/${1}/latest-git
        zip -qq -r ${PKG_ARCHIVE_NAME}-${1}.zip *;
        mv ${PKG_ARCHIVE_NAME}-${1}.zip ${WORKING_DIR}/${TMP}/${RELEASE_DIR};
        cd ${WORKING_DIR};
    fi
    if [[ ${make_os} = "osx" ]]; then
        cp -r ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit/node-webkit.app ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.app;
        cp -r ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.app/Contents/Resources/app.nw;
        rm -r ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw
        cp ${OSX_RESOURCE}/gisto.icns ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.app/Contents/Resources/
        cp ${OSX_RESOURCE}/Info.plist ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.app/Contents
        cd ${WORKING_DIR}/${TMP}/${1}/latest-git
        zip -qq -r ${PKG_ARCHIVE_NAME}-${1}.zip *;
        mv ${PKG_ARCHIVE_NAME}-${1}.zip ${WORKING_DIR}/${TMP}/${RELEASE_DIR};
        cd ${WORKING_DIR};
    fi
}

build() {
    for i in $(seq 0 5); do
        mkdir -p ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git;
        DL_FILE="${WORKING_DIR}/${TMP}/node-webkit-v${NW_VERSION}-${ARR_OS[$i]}.${ARR_DL_EXT[$i]}";
        if [[ ! -f ${DL_FILE} ]]; then
            printf "\n"
            NOTE 'WORKING'; printf "Bulding for ${TXT_BOLD}${TXT_YELLO}${ARR_OS[$i]}${TXT_RESET}\n"
            if [[ ${DEBUG} = "TRUE" ]]; then
                cp ${DEBUG_MODE_ARCHIVES}/node-webkit-v${NW_VERSION}-${ARR_OS[$i]}.${ARR_DL_EXT[$i]} ${WORKING_DIR}/${TMP};
            else
                wget -P ${WORKING_DIR}/${TMP} ${DL_URL}/v${NW_VERSION}/node-webkit-v${NW_VERSION}-${ARR_OS[$i]}.${ARR_DL_EXT[$i]};
            fi
            extractme "${ARR_EXTRACT_COMMAND[$i]}" "${DL_FILE}" "${WORKING_DIR}/${TMP}/${ARR_OS[$i]}";
            mv ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit-v${NW_VERSION}-${ARR_OS[$i]} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/node-webkit;

            if [[ `split_string "${ARR_OS[$i]}" "-"` = "osx" ]]; then
                cp -r ${WORKING_DIR}/${PKG_SRC} ${WORKING_DIR}/${TMP}/${ARR_OS[$i]}/latest-git/${PKG_NAME}.nw;
            else
                cd ${WORKING_DIR}/${PKG_SRC};
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
    printf "\n";
    NOTE 'DONE';
    printf "\n";
}

if [[ ${1} = "--clean" ]]; then
    clean;
elif [[ ${1} = "--build" ]]; then
    build;
elif [[ ${1} = "--help" ]]; then
    usage;
else
    usage;
fi
