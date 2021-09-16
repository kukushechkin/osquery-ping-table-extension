#!/bin/bash

PROJECT_DIR=$(dirname "$0")
pushd "$PROJECT_DIR" > /dev/null
PROJECT_DIR=$(pwd)
popd > /dev/null

[ -z "$OSQUERY_SOURCE_PATH" ] && {
	echo "OSQUERY_SOURCE_PATH is required"
	exit 1
}

# build ping library
swift build --package-path "$PROJECT_DIR"/swift-ping --configuration release || {
	echo "Failed to build the-ping lib"
	exit 2
}
PING_LIB_DIR=$(swift build --package-path "$PROJECT_DIR"/swift-ping --configuration release --show-bin-path)
echo "$PING_LIB_DIR"

# prepare osquery external extension build hook
extension_symlink_path="$OSQUERY_SOURCE_PATH"/external/extension_ping
[ -d "$extension_symlink_path" ] || ln -s "$PROJECT_DIR"/ping_table_extension "$extension_symlink_path"

# build extension
pushd "$OSQUERY_SOURCE_PATH" > /dev/null
[ -d build ] || mkdir build
cd build

cmake \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
	..

VERBOSE=1 make externals
popd > /dev/null

