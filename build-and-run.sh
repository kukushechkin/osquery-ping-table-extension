#!/bin/bash

PROJECT_DIR=$(dirname "$0")
pushd "$PROJECT_DIR" > /dev/null
PROJECT_DIR=$(pwd)
popd > /dev/null

EXTENSION_NAME=extension_ping

[ -z "$OSQUERY_SOURCE_PATH" ] && {
	echo "OSQUERY_SOURCE_PATH is required"
	exit 1
}

# build ping library
swift build --package-path "$PROJECT_DIR"/swift-ping --configuration release || {
	echo "Failed to build the-ping lib"
	exit 2
}
# TODO: pass to cmake
# PING_LIB_DIR=$(swift build --package-path "$PROJECT_DIR"/swift-ping --configuration release --show-bin-path)

# prepare osquery external extension build hook
extension_symlink_path="$OSQUERY_SOURCE_PATH"/external/$EXTENSION_NAME
[ -d "$extension_symlink_path" ] || ln -s "$PROJECT_DIR"/ping_table_extension "$extension_symlink_path"

pushd "$OSQUERY_SOURCE_PATH" > /dev/null

# run cmake
[ -d build ] || mkdir build
pushd build > /dev/null

cmake \
	-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
	.. || {
		echo "failed to run cmake"
		exit 3
	}
VERBOSE=1 make externals
popd > /dev/null

# build extension
pushd build/external/extension_ping > /dev/null
make || {
	echo "failed to build extension"
	exit 4
}
popd > /dev/null
popd > /dev/null

# What is cache variable I need to set to override default group name? Whatever.
DEFAULT_EXTENSION_GROUP_NAME=osquery_extension_group
EXTENSION_BINARY="$OSQUERY_SOURCE_PATH"/build/external/extension_ping/$DEFAULT_EXTENSION_GROUP_NAME.ext

# run extension
[ -f "$EXTENSION_BINARY" ] || {
	echo "extension artifact $EXTENSION_BINARY does not exist"
	exit 5
}
osqueryi --extension "$EXTENSION_BINARY"