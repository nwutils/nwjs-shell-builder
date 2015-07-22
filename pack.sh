#!/usr/bin/env bash

# Exit on error
set -e

BUILD_DIR=`pwd`
WORKING_DIR="${BUILD_DIR}/TMP"
RELEASE_DIR="${BUILD_DIR}/releases"

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

    NSIS, Zip, tar, ImageMagick

USAGE

    Building:
    $ ./pack.sh [--linux|--mac|--windows|--all]

    Hooks:
    Place hhoks in "./hooks/" directory
        - file name 'before.sh' will be executed befor each build
        - file name 'after.sh' will be executed after pack script is finished
        - file name 'after_build.sh' will be executed after each platform build is finished

EOF
}

check_dependencies() {
    # Check if NSIS is present
    if [[ "`makensis`" =~ "MakeNSIS" && "`convert`" =~ "Version: ImageMagick" ]]; then
        echo 'OK';
    else
        echo 'NO';
    fi
}

pack_linux () {
    for arch in ${architechture[@]}; do
        cd ${WORKING_DIR}
        cp -r ${BUILD_DIR}/resources/linux/PKGNAME-VERSION-Linux ${BUILD_DIR}/TMP/$(get_value_by_key name)-$(get_value_by_key version)-Linux-${arch}
        PKG_MK_DIR=${BUILD_DIR}/TMP/$(get_value_by_key name)-$(get_value_by_key version)-Linux-${arch}
        mv ${PKG_MK_DIR}/PKGNAME ${PKG_MK_DIR}/$(get_value_by_key name)
        mv ${PKG_MK_DIR}/$(get_value_by_key name)/PKGNAME ${PKG_MK_DIR}/$(get_value_by_key name)/$(get_value_by_key name)
        # replaces
        replace -s PKGNAME $(get_value_by_key name)} -- ${PKG_MK_DIR}/README
        replace -s PKGDESCRIPTION "$(get_value_by_key description)" -- ${PKG_MK_DIR}/README
        replace -s PKGNAME $(get_value_by_key name) -- ${PKG_MK_DIR}/$(get_value_by_key name)/$(get_value_by_key name)
        replace -s PKGNAME $(get_value_by_key name) -- ${PKG_MK_DIR}/setup
        # app file
        cp $(get_value_by_key iconPath) ${PKG_MK_DIR}/$(get_value_by_key name)/pixmaps/$(get_value_by_key name).png
        convert ${PKG_MK_DIR}/$(get_value_by_key name)/pixmaps/$(get_value_by_key name).png ${PKG_MK_DIR}/$(get_value_by_key name)/pixmaps/$(get_value_by_key name).xpm
        cp ${BUILD_DIR}/TMP/linux-${arch}/latest-git/* ${PKG_MK_DIR}/$(get_value_by_key name)/
        mv ${PKG_MK_DIR}/$(get_value_by_key name)/$(get_value_by_key name) ${PKG_MK_DIR}/$(get_value_by_key name)/$(get_value_by_key name)-bin
        # application
        mv ${PKG_MK_DIR}/share/applications/PKGNAME.desktop ${PKG_MK_DIR}/share/applications/$(get_value_by_key name).desktop
        replace -s PKGNAME $(get_value_by_key name) -- ${PKG_MK_DIR}/share/applications/$(get_value_by_key name).desktop
        replace -s PKGVERSION $(get_value_by_key version) -- ${PKG_MK_DIR}/share/applications/$(get_value_by_key name).desktop
        # menu
        mv ${PKG_MK_DIR}/share/menu/PKGNAME ${PKG_MK_DIR}/share/menu/$(get_value_by_key name)
        replace -s PKGNAME $(get_value_by_key name) -- ${PKG_MK_DIR}/share/menu/$(get_value_by_key name)
        # make the tar
        tar -C ${WORKING_DIR} -czf $(get_value_by_key name)-$(get_value_by_key version)-Linux-${arch}.tar.gz $(get_value_by_key name)-$(get_value_by_key version)-Linux-${arch}
        mv ${WORKING_DIR}/$(get_value_by_key name)-$(get_value_by_key version)-Linux-${arch}.tar.gz ${RELEASE_DIR}
        printf "\nDone Linux ${arch}\n"
    done;
}

pack_osx () {
    # TODO
    printf "\nNOTE! OSX packaging is not yet implemented\n\n";
}

pack_windows() {
    for arch in ${architechture[@]}; do
        cd ${WORKING_DIR}
        cp -r ${BUILD_DIR}/resources/windows/app.nsi ${WORKING_DIR}
        cp -r $(get_value_by_key windowsIconPath) ${BUILD_DIR}/TMP/win-${arch}/latest-git/
        # Replce paths and vars in nsi script
        replace \
            NWJS_APP_REPLACE_APPNAME "$(get_value_by_key name)" \
            NWJS_APP_REPLACE_DESCRIPTION "$(get_value_by_key description)" \
            NWJS_APP_REPLACE_LICENSE $(get_value_by_key license) \
            NWJS_APP_REPLACE_VERSION $(get_value_by_key version) \
            NWJS_APP_REPLACE_EXE_NAME $(get_value_by_key name)-$(get_value_by_key version)-Windows-${arch}.exe \
            NWJS_APP_REPLACE_INC_FILE_1 ${BUILD_DIR}/TMP/win-${arch}/latest-git/$(get_value_by_key name).exe \
            NWJS_APP_REPLACE_INC_FILE_2 ${BUILD_DIR}/TMP/win-${arch}/latest-git/icudtl.dat \
            NWJS_APP_REPLACE_INC_FILE_3 ${BUILD_DIR}/TMP/win-${arch}/latest-git/libEGL.dll \
            NWJS_APP_REPLACE_INC_FILE_4 ${BUILD_DIR}/TMP/win-${arch}/latest-git/libGLESv2.dll \
            NWJS_APP_REPLACE_INC_FILE_5 ${BUILD_DIR}/TMP/win-${arch}/latest-git/nw.pak \
            NWJS_APP_REPLACE_INC_FILE_6 ${BUILD_DIR}/TMP/win-${arch}/latest-git/d3dcompiler_47.dll \
            NWJS_APP_REPLACE_ICO_FILE_NAME $(basename $(get_value_by_key windowsIconPath)) \
            NWJS_APP_REPLACE_INC_FILE_ICO $(get_value_by_key windowsIconPath) -- app.nsi;
        makensis app.nsi
        # Clean a bit
        rm -rf ${WORKING_DIR}/$(get_value_by_key name).nsi;
        mv ${WORKING_DIR}/$(get_value_by_key name)-$(get_value_by_key version)-Windows-${arch}.exe ${RELEASE_DIR}
        printf "\nDone Windows ${arch}\n"
    done
}

build() {
    if [[ `check_dependencies` = "NO" ]]; then
        printf "\nNOTE! NSIS or ImageMagick is missing in the system\n\n";
        exit 1;
    fi
    if [[ ! -d "${RELEASE_DIR}" ]]; then
        mkdir ${RELEASE_DIR}
    fi
    ${BUILD_DIR}/nwjs-build.sh \
        --src=$(get_value_by_key src) \
        --name=$(get_value_by_key name) \
        --nw=$(get_value_by_key nwjsVersion) \
        --win-icon=$(get_value_by_key windowsIconPath) \
        --target="${1}" \
        --version=$(get_value_by_key version) \
        --build
    cd ${BUILD_DIR}
}

# Execute hooks
hook() {
    printf "\nNOTE! \"${1}\" hook executed\n\n";
    case "$1" in
        before)
            ${BUILD_DIR}/hooks/before.sh
            ;;
        after)
            ${BUILD_DIR}/hooks/after.sh
            ;;
        after_build)
            ${BUILD_DIR}/hooks/after_build.sh
            ;;
    esac
}

# TODO maybe deal with cmd switches or leave it all in the config.json file

if [[ ${1} = "--help" || ${1} = "-h" ]]; then
    usage;
elif [[ ${1} = "--clean" ]]; then
    rm -rf ${WORKING_DIR}
elif [[ ${1} = "--linux" ]]; then
    hook "before";
    build "0 1";
    hook "after_build";
    pack_linux;
    hook "after";
elif [[ ${1} = "--osx" ]]; then
    hook "before";
    build "4 5";
    hook "after_build";
    pack_osx;
    hook "after";
elif [[ ${1} = "--windows" ]]; then
    hook "before";
    build "2 3";
    hook "after_build";
    pack_windows;
    hook "after";
elif [[ ${1} = "--all" ]]; then
    hook "before";
    build "0 1 2 3 4 5";
    hook "after_build";
    pack_osx;
    pack_linux;
    pack_windows;
    hook "after";
else
    usage;
fi
