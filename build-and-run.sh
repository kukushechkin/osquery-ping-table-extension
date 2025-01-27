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
PING_LIB_NAME=single-ping-lib
swift test --package-path "$PROJECT_DIR"/$PING_LIB_NAME || {
	echo "$PING_LIB_NAME tests failed"
	exit 2	
}
swift build --package-path "$PROJECT_DIR"/$PING_LIB_NAME --configuration release || {
	echo "Failed to build $PING_LIB_NAME lib"
	exit 2
}
PING_LIB_DIR=$(swift build --package-path "$PROJECT_DIR"/$PING_LIB_NAME --configuration release --show-bin-path)

echo PING_LIB_NAME=$PING_LIB_NAME
echo PING_LIB_DIR=$PING_LIB_DIR
echo PING_HEADERS_DIR="$PROJECT_DIR"/$PING_LIB_NAME/Sources/$PING_LIB_NAME/include

# prepare osquery external extension build hook
extension_symlink_path="$OSQUERY_SOURCE_PATH"/external/$EXTENSION_NAME
[ -d "$extension_symlink_path" ] || ln -s "$PROJECT_DIR"/ping_table_extension "$extension_symlink_path"

pushd "$OSQUERY_SOURCE_PATH" > /dev/null

# run cmake
[ -d build ] || mkdir build
pushd build > /dev/null

PING_LIB_NAME=$PING_LIB_NAME \
PING_LIB_DIR=$PING_LIB_DIR \
PING_HEADERS_DIR="$PROJECT_DIR"/$PING_LIB_NAME/Sources/$PING_LIB_NAME/include \
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

echo "sample queries:"
echo "	select * from ping where (host = '127.0.0.1' or host = 'apple.com') and latency < '0.03';";
echo "	select * from ping where host = '127.0.0.1' or host = 'apple.com' or host = 'asdklajslkja';";
osqueryi --extension "$EXTENSION_BINARY"