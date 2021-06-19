# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(nomos LANGUAGES C)
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS}")
include(FindPkgConfig)
include(FindPostgreSQL)
pkg_check_modules(GLIB REQUIRED glib-2.0)
pkg_check_modules(JSONC REQUIRED json-c)

include_directories(
    ${GLIB_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
)
if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

add_executable(encode ${FO_CWD}/encode.c)

add_custom_command(
    OUTPUT ${FO_CWD}/_autodefs.h ${FO_CWD}/_autodata.c
    COMMAND echo "NOTE: GENSEARCHDATA takes 1-2 minutes to run"
    COMMAND ${FO_CWD}/GENSEARCHDATA
    WORKING_DIRECTORY ${FO_CWD}/
    DEPENDS encode
)

add_custom_command(
    OUTPUT ${FO_CWD}/_precheck.c
    COMMAND ${FO_CWD}/PRECHECK
    COMMAND ${FO_CWD}/CHECKSTR
    WORKING_DIRECTORY ${FO_CWD}/
    DEPENDS ${FO_CWD}/_autodata.c
)

add_library(nomos "")
add_library(nomos_cov EXCLUDE_FROM_ALL "")
add_executable(nomos_exec "")
add_executable(nomos_cov_exec EXCLUDE_FROM_ALL "")

foreach(FO_NOM_TARGET nomos nomos_cov nomos_exec nomos_cov_exec)
    target_sources(${FO_NOM_TARGET}
        PRIVATE
        ${FO_CWD}/nomos.c
        ${FO_CWD}/licenses.c
        ${FO_CWD}/list.c
        ${FO_CWD}/parse.c
        ${FO_CWD}/process.c
        ${FO_CWD}/nomos_regex.c
        ${FO_CWD}/util.c
        ${FO_CWD}/nomos_gap.c
        ${FO_CWD}/nomos_utils.c
        ${FO_CWD}/doctorBuffer_utils.c
        ${FO_CWD}/json_writer.c
        ${FO_CWD}/nomos.h
        ${FO_CWD}/licenses.h
        ${FO_CWD}/list.h
        ${FO_CWD}/parse.h
        ${FO_CWD}/process.h
        ${FO_CWD}/nomos_regex.h
        ${FO_CWD}/util.h
        ${FO_CWD}/nomos_gap.h
        ${FO_CWD}/nomos_utils.h
        ${FO_CWD}/doctorBuffer_utils.h
        ${FO_CWD}/json_writer.h
        ${FO_CWD}/_autodefs.h
        ${FO_CWD}/_autodata.c
        ${FO_CWD}/_precheck.c
    )
    target_compile_definitions(${FO_NOM_TARGET} PRIVATE _FILE_OFFSET_BITS=64)
    if(${FO_NOM_TARGET} MATCHES "cov")
        target_compile_options(${FO_NOM_TARGET} PRIVATE ${FO_COV_FLAGS})
    endif()
    if(${FO_NOM_TARGET} MATCHES "_exec$")
        target_link_libraries(${FO_NOM_TARGET} 
            PRIVATE 
            fossology
            ${JSONC_LIBRARIES}
            pthread
            rt
        )
        string(REPLACE "_exec" "" FO_NOM_TARGET_R ${FO_NOM_TARGET})
        set_target_properties(${FO_NOM_TARGET}
            PROPERTIES OUTPUT_NAME ${FO_NOM_TARGET_R})
        # HACK: add dependency of executable on libraries to force sequence
        add_dependencies(${FO_NOM_TARGET} ${FO_NOM_TARGET_R}) 
    endif()
endforeach()

# TODO: add VERSION and COMMIT ID 
# FIXME: nomos coverage not building
