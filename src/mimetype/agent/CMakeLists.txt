# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(mimetype LANGUAGES C)
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
    ${FO_CLIB_SRC}
)
if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

add_library(mimetype "")
add_library(mimetype_cov EXCLUDE_FROM_ALL "")

foreach(FO_MIME_TARGET mimetype mimetype_cov)
    target_sources(${FO_MIME_TARGET}
        PRIVATE
        ${FO_CWD}/mimetype.c
        ${FO_CWD}/finder.c
        ${FO_CWD}/finder.h
    )
    target_compile_definitions(${FO_MIME_TARGET}
        PRIVATE _FILE_OFFSET_BITS=64)
endforeach()
target_compile_options(mimetype_cov PRIVATE ${FO_COV_FLAGS})

add_executable(mimetype_exec "")
target_sources(mimetype_exec PRIVATE ${FO_CWD}/mimetype.c)

target_link_libraries(mimetype_exec PRIVATE fossology magic mimetype)
set_target_properties(mimetype_exec PROPERTIES OUTPUT_NAME mimetype)

# TODO: add VERSION and COMMIT ID 