#!/usr/bin/env bash

# Exit on error
set -e

BUILD_DIR=`pwd`
WORKING_DIR="${BUILD_DIR}/TMP"

get_value_by_key() {
    JSON_FILE=${BUILD_DIR}/config.json
    KEY=${1}
    REGEX="(?<=\"${KEY}\":.\")[^\"]*"
    JSON_VALUE=$(cat ${JSON_FILE} | grep -Po ${REGEX})
    echo ${JSON_VALUE}
}

# Name of your package
PKG_NAME=$(get_value_by_key name)

if [[ ! -f "${WORKING_DIR}" ]]; then
    mkdir -p TMP
fi

cd TMP

architechture="ia32 x64"

usage() {
clear && cat <<EOF

NAME

    NWJS app pack script

DESCRIPTION

    Build installers for Windows, Linux and OSX

DEPENDENCIES

USAGE
    Building:
            $ ./pack.sh

EOF
}

check_dependencies() {
    # Check if CMAKE is present
    if [[ "`makensis`" =~ "MakeNSIS" ]]; then
        echo 'OK';
    else
        echo 'NO';
    fi
}

mklinux () {
    # TODO
    printf "\nNOTE! Linux packaging is not yet implemented\n\n";
}

mkosx () {
    # TODO
    printf "\nNOTE! OSX packaging is not yet implemented\n\n";
}

mkwindows() {
    for arch in ${architechture[@]}; do
        cd ${WORKING_DIR}
        cp -r ${BUILD_DIR}/resources/windows/app.nsi ${WORKING_DIR}
        cp -r $(get_value_by_key windowsIconPath) ${BUILD_DIR}/TMP/win-${arch}/latest-git/
        # Replce paths and vars in nsi script
        replace \
            NWJS_APP_REPLACE_APPNAME $(get_value_by_key name) \
            NWJS_APP_REPLACE_LICENSE $(get_value_by_key license) \
            NWJS_APP_REPLACE_VERSION $(get_value_by_key version) \
            NWJS_APP_REPLACE_EXE_NAME $(get_value_by_key name)-$(get_value_by_key version)-Windows-${arch}.exe \
            NWJS_APP_REPLACE_INC_FILE_1 ${BUILD_DIR}/TMP/win-${arch}/latest-git/$(get_value_by_key name).exe \
            NWJS_APP_REPLACE_INC_FILE_2 ${BUILD_DIR}/TMP/win-${arch}/latest-git/icudtl.dat \
            NWJS_APP_REPLACE_INC_FILE_3 ${BUILD_DIR}/TMP/win-${arch}/latest-git/libEGL.dll \
            NWJS_APP_REPLACE_INC_FILE_4 ${BUILD_DIR}/TMP/win-${arch}/latest-git/libGLESv2.dll \
            NWJS_APP_REPLACE_INC_FILE_5 ${BUILD_DIR}/TMP/win-${arch}/latest-git/nw.pak \
            NWJS_APP_REPLACE_INC_FILE_6 ${BUILD_DIR}/TMP/win-${arch}/latest-git/d3dcompiler_47.dll \
            NWJS_APP_REPLACE_INC_FILE_ICO $(get_value_by_key windowsIconPath) -- app.nsi;
        makensis app.nsi
        # Clean a bit
        rm -rf ${WORKING_DIR}/$(get_value_by_key name).nsi;
        printf "\nDone Windows ${arch}\n"
    done
}

prepare() {
    ${BUILD_DIR}/nwjs-build.sh \
        --src=$(get_value_by_key src) \
        --name=$(get_value_by_key name) \
        --nw=$(get_value_by_key nwjsVersion) \
        --win-icon=$(get_value_by_key windowsIconPath) \
        --target="2 3" \
        --version=$(get_value_by_key version) \
        --build
    cd ${BUILD_DIR}
}

if [[ `check_dependencies` = "NO" ]]; then
    printf "\nNOTE!     NSIS is missing in the system\n\n";
    exit 1;
fi
prepare;
mkwindows;


#if [[ ${1} != "--clean" && ${2} = "" ]];then
#    printf "\nVersion is required 2nd parameter\n"
#elif [[ ${1} = "--help" || ${1} = "-h" ]]; then
#    usage;
#elif [[ ${1} = "--clean" ]]; then
#    rm -rf ${WORKING_DIR}
#    rm -rf ${PROJECT_DIR}/build/script/TMP
#elif [[ ${1} = "--linux" ]]; then
#    prepare ${2} "0 1" ${3};
#    mklinux ${2};
#elif [[ ${1} = "--osx" ]]; then
#    prepare ${2} "4 5" ${3};
#    mkosx ${2};
#elif [[ ${1} = "--windows" ]]; then
#    prepare ${2} "2 3" ${3};
#    mkwindows ${2};
#elif [[ ${1} = "--all" ]]; then
#    prepare ${2} "0 1 2 3 4 5" ${3};
#    mkosx ${2};
#    mklinux ${2};
#    mkwindows ${2};
#else
#    usage;
#fi
