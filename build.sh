#!/bin/bash

PROJECT_DIR=$(dirname "$0")
pushd "$PROJECT_DIR" > /dev/null
PROJECT_DIR=$(pwd)
popd > /dev/null

[ -z "$OSQUERY_SOURCE_PATH" ] && {
	echo "OSQUERY_SOURCE_PATH is required"
	exit 1
}

extension_symlink_path="$OSQUERY_SOURCE_PATH"/external/ping_extension
[ -d "$extension_symlink_path" ] || ln -s "$PROJECT_DIR"/ping_table_extension "$extension_symlink_path"

pushd "$OSQUERY_SOURCE_PATH" > /dev/null
[ -d build ] || mkdir build
cd build

cmake \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
	..

make externals
popd > /dev/null