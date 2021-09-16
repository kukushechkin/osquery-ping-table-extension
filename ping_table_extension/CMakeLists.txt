cmake_minimum_required(VERSION 3.21)

# TODO: add SPM build to CMakeLists.txt to not to use relative path

addOsqueryExtensionEx("PingTableExt" "table" "ping"
  SOURCES src/ping_ext.cpp
  INCLUDEDIRS "$ENV{PING_HEADERS_DIR}"
  MAININCLUDES "${CMAKE_CURRENT_SOURCE_DIR}/src/ping_ext.h"
  LIBRARIES
    $ENV{PING_LIB_NAME}
)

link_directories(
  "$ENV{PING_LIB_DIR}"
)

# oh, ffs
generateOsqueryExtensionGroup()