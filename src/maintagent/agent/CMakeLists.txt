# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(maintagent LANGUAGES C)
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS}")
include(FindPkgConfig)
include(FindPostgreSQL)
pkg_check_modules(GLIB REQUIRED glib-2.0)

include_directories(
    ${GLIB_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
)
if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

add_executable(maintagent "")
target_sources(maintagent
    PRIVATE
    ${FO_CWD}/maintagent.c
    ${FO_CWD}/maintagent.h
    ${FO_CWD}/utils.c
    ${FO_CWD}/process.c
    ${FO_CWD}/usage.c
)
target_compile_definitions(maintagent
    PRIVATE
    PROJECTSTATEDIR="${FO_PROJECTSTATEDIR}"
    DATADIR="${FO_DATADIR}"
    _FILE_OFFSET_BITS=64
)
target_link_libraries(maintagent PRIVATE fossology)


# TODO: add VERSION and COMMIT ID 