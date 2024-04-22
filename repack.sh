#!/bin/sh

COMMON_VERSION="0.5.0"

epm tool eget https://raw.githubusercontent.com/alt-autorepacked/common/v$COMMON_VERSION/common.sh
. ./common.sh

_package="Trezor-Suite"

arch="$(epm print info -a)"
case "$arch" in
    x86_64)
        arch=x86_64
        ;;
    aarch64)
        arch=arm64
        ;;
    *)
        fatal "$arch arch is not supported"
        ;;
esac

GITHUB_REPO="trezor/trezor-suite"
GITHUB_SUFFIX="*-linux-$arch.AppImage"

download_version=$(_check_version_from_github)
remote_version=$(_check_version_from_remote)

if [ "$remote_version" != "$download_version" ]; then
    _download_from_github
    _add_repo_suffix
    TAG="v$download_version"
    _create_release
    echo "Release created: $TAG"
else
    echo "No new version to release. Current version: $download_version"
fi

rm common.sh