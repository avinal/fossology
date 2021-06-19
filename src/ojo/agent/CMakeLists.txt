# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(ojo LANGUAGES CXX)
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -fopenmp")
find_package(Boost REQUIRED regex system filesystem program_options)
include(FindPkgConfig)
include(FindPostgreSQL)
pkg_check_modules(GLIB REQUIRED glib-2.0)
pkg_check_modules(JSONCPP REQUIRED jsoncpp)

include_directories(
    ${GLIB_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
    ${JSONCPP_INCLUDE_DIRS}
    ${FO_CXXLIB_SRC}
)

add_compile_definitions( _FILE_OFFSET_BITS=64 DATADIR="${FO_MODDIR}")

if(NOT TARGET fossologyCPP)
    add_subdirectory(${FO_CXXLIB_SRC} buildcxx EXCLUDE_FROM_ALL)
endif()

add_library(ojo EXCLUDE_FROM_ALL "")
add_library(ojo_cov EXCLUDE_FROM_ALL "")
add_executable(ojo_exec "")
add_executable(ojo_cov_exec EXCLUDE_FROM_ALL "")
foreach(FO_OJO_TARGET ojo ojo_exec ojo_cov ojo_cov_exec)
    target_sources(${FO_OJO_TARGET}
        PRIVATE
        ${FO_CWD}/OjosDatabaseHandler.cc
        ${FO_CWD}/ojoregex.cc
        ${FO_CWD}/ojos.cc
        ${FO_CWD}/OjoAgent.cc
        ${FO_CWD}/OjoState.cc
        ${FO_CWD}/directoryScan.cc
        ${FO_CWD}/OjoUtils.cc
        ${FO_CWD}/OjosDatabaseHandler.hpp
        ${FO_CWD}/ojoregex.hpp
        ${FO_CWD}/ojos.hpp
        ${FO_CWD}/OjoAgent.hpp
        ${FO_CWD}/OjoState.hpp
        ${FO_CWD}/directoryScan.hpp
        ${FO_CWD}/OjoUtils.hpp
    )
    if(${FO_OJO_TARGET} MATCHES "^ojo_cov")
        target_compile_options(${FO_OJO_TARGET}
            PRIVATE ${FO_COV_FLAGS})
    endif()
    if(${FO_OJO_TARGET} MATCHES "_exec$")
        target_link_libraries(${FO_OJO_TARGET} 
            PRIVATE fossologyCPP icuuc ${Boost_LIBRARIES} ${JSONCPP_LIBRARIES})
        string(REPLACE "_exec" "" FO_OJO_TARGET_R ${FO_OJO_TARGET})
        set_target_properties(${FO_OJO_TARGET}
            PROPERTIES OUTPUT_NAME ${FO_OJO_TARGET_R})
    endif()
endforeach()

# FIXME: coverage build is failing
# TODO: add VERSION and COMMIT ID 