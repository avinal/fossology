#[[--------------------------------------------------------------------
SPDX-License-Identifier: GPL-2.0
SPDX-FileCopyrightText: 2021 Avinal Kumar <avinal.xlvii@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
version 2 as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
---------------------------------------------------------------------]]

cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(ninka LANGUAGES CXX)
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
# set defaults

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -fopenmp")

include_directories(
    ${ninka_SOURCE_DIR}
    ${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
    ${FO_CXXLIB_SRC}
)
if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()
add_compile_definitions(
    _FILE_OFFSET_BITS=64
    DATADIR="${FO_MODDIR}"
    VERSION_S="${FO_VERSION}"
    COMMIT_HASH_S="${FO_COMMIT_HASH}"
)
if(NOT TARGET fossologyCPP)
    add_subdirectory(${FO_CXXLIB_SRC} buildcxx EXCLUDE_FROM_ALL)
endif()

add_library(ninka EXCLUDE_FROM_ALL "")
add_library(ninka_cov EXCLUDE_FROM_ALL "")
add_executable(ninka_exec "")
add_executable(ninka_cov_exec EXCLUDE_FROM_ALL "")
foreach(FO_NINKA_TARGET ninka ninka_exec ninka_cov ninka_cov_exec)
    target_sources(${FO_NINKA_TARGET}
        PRIVATE
        ${FO_CWD}/databasehandler.cc
        ${FO_CWD}/licensematch.cc
        ${FO_CWD}/ninka.cc
        ${FO_CWD}/ninkawrapper.cc
        ${FO_CWD}/state.cc
        ${FO_CWD}/utils.cc
    )
    if(${FO_NINKA_TARGET} MATCHES "^ninka_cov")
        target_compile_options(${FO_NINKA_TARGET}
            PUBLIC ${FO_COV_FLAGS})
            message(${FO_NINKA_TARGET})
    endif()
    if(${FO_NINKA_TARGET} MATCHES "_exec$")
        target_link_libraries(${FO_NINKA_TARGET} 
            PRIVATE 
            fossologyCPP
            stdc++
            icuuc
            icudata
            gcov
        )
        string(REPLACE "_exec" "" FO_NINKA_TARGET_R ${FO_NINKA_TARGET})
        set_target_properties(${FO_NINKA_TARGET}
            PROPERTIES OUTPUT_NAME ${FO_NINKA_TARGET_R})
    endif()
endforeach()

# FIXME: coverage build is failing
# TODO: come back later as agent is deprecated