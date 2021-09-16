cmake_minimum_required(VERSION 3.21)

# TODO: add SPM build to CMakeLists.txt to not to use relative path

addOsqueryExtensionEx("PingTableExt" "table" "ping"
  SOURCES src/ping_ext.cpp
  INCLUDEDIRS "${CMAKE_CURRENT_SOURCE_DIR}/../swift-ping/Sources/the-ping/include"
  MAININCLUDES "${CMAKE_CURRENT_SOURCE_DIR}/src/ping_ext.h"
  LIBRARIES
    the-ping.a
)

link_directories(
  "${CMAKE_CURRENT_SOURCE_DIR}/../swift-ping/.build/x86_64-apple-macosx/release"
)

# oh, ffs
generateOsqueryExtensionGroup()