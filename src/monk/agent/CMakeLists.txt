# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(monk LANGUAGES C)
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS} -std=c99 -Wextra -fopenmp")
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

add_executable(squareBuilder EXCLUDE_FROM_ALL buildSquareVisitor.c)
target_link_libraries(squareBuilder PRIVATE fossology m magic)
add_custom_command(
    OUTPUT ${FO_CWD}/_squareVisitor.c ${FO_CWD}/_squareVisitor.h
    COMMAND ${FO_CWD}/genSquareVisitor
    WORKING_DIRECTORY ${FO_CWD}/
    DEPENDS squareBuilder
)

add_library(monk EXCLUDE_FROM_ALL "")
add_library(monk_cov EXCLUDE_FROM_ALL "")
add_executable(monk_exec "")
add_executable(monkbulk "")

foreach(FO_MONK_TARGET monk monk_exec monk_cov monkbulk)
    if(${FO_MONK_TARGET} STREQUAL "monk")
        set(MONK_XSRC "monk.c" "monk.h")
    elseif(${FO_MONK_TARGET} STREQUAL "monkbulk")
        set(MONK_XSRC "monkbulk.c" "monkbulk.h")
    endif()
    target_sources(${FO_MONK_TARGET}
        PRIVATE
        ${FO_CWD}/string_operations.c
        ${FO_CWD}/file_operations.c
        ${FO_CWD}/database.c
        ${FO_CWD}/encoding.c
        ${FO_CWD}/license.c
        ${FO_CWD}/match.c
        ${FO_CWD}/highlight.c
        ${FO_CWD}/hash.c
        ${FO_CWD}/diff.c
        ${FO_CWD}/common.c
        ${FO_CWD}/cli.c
        ${FO_CWD}/scheduler.c
        ${FO_CWD}/serialize.c
        ${FO_CWD}/string_operations.h
        ${FO_CWD}/file_operations.h
        ${FO_CWD}/database.h
        ${FO_CWD}/encoding.h
        ${FO_CWD}/license.h
        ${FO_CWD}/match.h
        ${FO_CWD}/highlight.h
        ${FO_CWD}/hash.h
        ${FO_CWD}/diff.h
        ${FO_CWD}/common.h
        ${FO_CWD}/cli.h
        ${FO_CWD}/scheduler.h
        ${FO_CWD}/serialize.h
        ${FO_CWD}/${MONK_XSRC}
        ${FO_CWD}/_squareVisitor.c
        ${FO_CWD}/_squareVisitor.h
    )
    target_link_libraries(${FO_MONK_TARGET} PRIVATE fossology magic)
    target_compile_definitions(${FO_MONK_TARGET} PRIVATE _FILE_OFFSET_BITS=64)
endforeach()

set_target_properties(monk_exec
        PROPERTIES OUTPUT_NAME monk)


# TODO: add VERSION and COMMIT ID 