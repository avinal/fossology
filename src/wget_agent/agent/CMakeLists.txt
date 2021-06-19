# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(wget_agent LANGUAGES C)
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

if(NOT TARGET checksum)
    add_subdirectory(${FO_SOURCEDIR}/ununpack buildchk EXCLUDE_FROM_ALL)
endif()

add_compile_definitions(_FILE_OFFSET_BITS=64)

add_library(wget_agent EXCLUDE_FROM_ALL "")
add_library(wget_agent_cov EXCLUDE_FROM_ALL "")
add_executable(wget_agent_exec "")

foreach(FO_WGET_TARGET wget_agent wget_agent_exec wget_agent_cov)
    if(${FO_WGET_TARGET} STREQUAL "wget_agent_exec")
        target_link_libraries(${FO_WGET_TARGET} 
            PRIVATE 
            fossology
            wget_agent
            gcrypt
            checksum 
        )
        set_target_properties(${FO_WGET_TARGET} 
            PROPERTIES OUTPUT_NAME wget_agent)
        set(WGET_XSRC "main.c")
    else()
        set(WGET_XSRC "")
    endif()
    target_sources(${FO_WGET_TARGET}
        PRIVATE
        ${FO_CWD}/wget_agent.c
        ${FO_CWD}/wget_agent.h
        ${FO_CWD}/${WGET_XSRC}
    )
    if(${FO_WGET_TARGET} STREQUAL "wget_agent_cov")
        target_compile_options(${FO_WGET_TARGET} PRIVATE ${FO_COV_FLAGS})
    endif()
endforeach()

# TODO: add VERSION and COMMIT ID 