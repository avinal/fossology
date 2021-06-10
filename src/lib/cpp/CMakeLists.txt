# set minimum cmake version required
cmake_minimum_required(VERSION 3.10)
project(fossologyCPP LANGUAGES CXX)
# set(CMAKE_VERBOSE_MAKEFILE ON)
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -fPIC -Wextra -Weffc++")
add_compile_definitions(
    FOSSDB_CONF="${FO_SYSCONFDIR}/Db.conf" 
    FOSSGROUP="${FO_PROJECTGROUP}" 
    DEFAULT_SETUP="${FO_SYSCONFDIR}"
    _FILE_OFFSET_BITS=64
)

include(FindPkgConfig)
include(FindPostgreSQL)
pkg_check_modules(GLIB REQUIRED glib-2.0)
include_directories(
    ${GLIB_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
)

if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

add_library(fossologyCPP "")
target_sources(fossologyCPP
    PRIVATE
        ${FO_CWD}/libfossAgentDatabaseHandler.cc
        ${FO_CWD}/libfossdbmanagerclass.cc
        ${FO_CWD}/files.cc
        ${FO_CWD}/libfossdbQueryResult.cc
        ${FO_CWD}/libfossUtils.cc
    PUBLIC
        ${FO_CWD}/libfossAgentDatabaseHandler.hpp
        ${FO_CWD}/libfossdbmanagerclass.hpp
        ${FO_CWD}/files.hpp
        ${FO_CWD}/libfossdbQueryResult.hpp
        ${FO_CWD}/libfossUtils.hpp
)

target_link_libraries(fossologyCPP PRIVATE fossology)

target_include_directories(fossologyCPP 
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>)
