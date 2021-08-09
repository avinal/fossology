#[=======================================================================[
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
#]=======================================================================]

cmake_minimum_required(VERSION 3.10)
project(libcpp LANGUAGES CXX)

set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -fPIC -Wextra -Weffc++")
add_compile_definitions(
    FOSSDB_CONF="${FO_SYSCONFDIR}/Db.conf" 
    FOSSGROUP="${FO_PROJECTGROUP}" 
    DEFAULT_SETUP="${FO_SYSCONFDIR}"
    _FILE_OFFSET_BITS=64)

include_directories(
    ${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC})

if(NOT TARGET fossology)
    set(NOSUBTEST TRUE)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

add_library(fossologyCPP "")
target_sources(fossologyCPP
    PRIVATE
        ${FO_CWD}/libfossAgentDatabaseHandler.cc
        ${FO_CWD}/libfossdbmanagerclass.cc
        ${FO_CWD}/files.cc
        ${FO_CWD}/libfossdbQueryResult.cc
        ${FO_CWD}/libfossUtils.cc)

target_link_libraries(fossologyCPP PRIVATE fossology)

target_include_directories(fossologyCPP 
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>)
if(TESTING)
    enable_testing()
    add_subdirectory(tests EXCLUDE_FROM_ALL)
endif()
install(TARGETS fossologyCPP
    ARCHIVE
    DESTINATION ${FO_LIBEXECDIR}
    COMPONENT lib)

install(FILES ${FO_CWD}/libfossologyCPP.hpp 
    DESTINATION ${FO_INCLUDEDIR}
    COMPONENT lib)

enable_language(C)
enable_testing()
add_subdirectory(tests)