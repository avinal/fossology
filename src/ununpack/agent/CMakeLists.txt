# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(ununpack LANGUAGES C)
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
add_compile_definitions(
    _FILE_OFFSET_BITS=64
)

add_library(ununpack EXCLUDE_FROM_ALL "")
add_library(ununpack_cov EXCLUDE_FROM_ALL "")
foreach(FO_UNP_LIB ununpack  ununpack_cov)
    target_sources(${FO_UNP_LIB}
        PRIVATE
        ${FO_CWD}/traverse.c
        ${FO_CWD}/ununpack-iso.c
        ${FO_CWD}/ununpack-ar.c
        ${FO_CWD}/ununpack-disk.c
        ${FO_CWD}/utils.c
        ${FO_CWD}/ununpack.h
        ${FO_CWD}/ununpack-iso.h
        ${FO_CWD}/ununpack-ar.h
        ${FO_CWD}/ununpack-disk.h
        ${FO_CWD}/ununpack_globals.h
        ${FO_CWD}/checksum.h
        ${FO_CWD}/checksum.c
    )
    target_link_libraries(${FO_UNP_LIB}
        PRIVATE
        fossology
        gcrypt)
endforeach()

add_executable(departition "")
add_executable(departition-coverage EXCLUDE_FROM_ALL "")
add_executable(ununpack_exec "")
add_executable(ununpack-coverage EXCLUDE_FROM_ALL "")

foreach(FO_UNP_EXEC departition departition-coverage ununpack_exec ununpack-coverage)
    if(${FO_UNP_EXEC} MATCHES "^departition")
        set(UNP_XSRC "${FO_CWD}/departition.c")
        set(UNP_XLIB "fossology")
    elseif(${FO_UNP_EXEC} MATCHES "^ununpack")
        set(UNP_XSRC "${FO_CWD}/ununpack.c")
        if(${FO_UNP_EXEC} STREQUAL "ununpack_exec")
            set(UNP_XLIB "ununpack" "magic")
        else()
            set(UNP_XLIB "ununpack_cov" "magic")
        endif()
    endif()
    target_sources(${FO_UNP_EXEC} PRIVATE ${UNP_XSRC})
    target_link_libraries(${FO_UNP_EXEC} PRIVATE ${UNP_XLIB})
endforeach()

foreach(FO_UNP_COV ununpack_cov ununpack-coverage departition-coverage)
    target_compile_options(${FO_UNP_COV} PRIVATE ${FO_COV_FLAGS})
endforeach()

set_target_properties(ununpack_exec PROPERTIES OUTPUT_NAME ununpack)

add_library(checksum OBJECT EXCLUDE_FROM_ALL 
    ${FO_CWD}/checksum.h ${FO_CWD}/checksum.c)

# TODO: add VERSION and COMMIT ID 
# FIXME:coverage build is failing