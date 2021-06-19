# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(adj2nest LANGUAGES C)
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS} -fPIC")

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


add_executable(adj2nest "")
target_sources(adj2nest PRIVATE ${FO_CWD}/adj2nest.c)
target_compile_definitions(adj2nest PRIVATE _FILE_OFFSET_BITS=64)
target_link_libraries(adj2nest PRIVATE fossology)
