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

cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(libc LANGUAGES C)

include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -Wall")
add_compile_definitions(
    FOSSDB_CONF="${FO_SYSCONFDIR}/Db.conf"
    FOSSGROUP="${FO_PROJECTGROUP}" 
    DEFAULT_SETUP="${FO_SYSCONFDIR}"
    _FILE_OFFSET_BITS=64)

include_directories(
    ${fossology_SOURCE_DIR}
    ${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS})

add_library(fossology "")
add_library(fossology_cov EXCLUDE_FROM_ALL "")
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
foreach(FO_CLIB_TARGET fossology fossology_cov)
    target_sources(${FO_CLIB_TARGET}
        PRIVATE
            ${FO_CWD}/libfossscheduler.c
            ${FO_CWD}/libfossdb.c
            ${FO_CWD}/libfossagent.c
            ${FO_CWD}/libfossrepo.c
            ${FO_CWD}/libfossdbmanager.c
            ${FO_CWD}/fossconfig.c
            ${FO_CWD}/sqlCopy.c)
    target_link_libraries(${FO_CLIB_TARGET}
        PRIVATE ${glib_LIBRARIES} ${PostgreSQL_LIBRARIES})
endforeach()

target_compile_options(fossology_cov PRIVATE ${FO_COV_FLAGS})

if(TESTING)
    enable_testing()
    add_subdirectory(tests)
endif()

foreach(FO_CLIB_EXEC sqlCopyTest fossconfigTest reppath)
    add_executable(${FO_CLIB_EXEC} "")
    target_sources(${FO_CLIB_EXEC} PRIVATE ${FO_CLIB_EXEC}.c)
    target_link_libraries(${FO_CLIB_EXEC} PRIVATE fossology)
endforeach()

target_include_directories(fossology 
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>)

install(TARGETS fossology sqlCopyTest fossconfigTest reppath 
    RUNTIME DESTINATION ${FO_LIBEXECDIR}
    ARCHIVE DESTINATION ${FO_LIBEXECDIR}
    COMPONENT lib)

install(FILES ${FO_CWD}/libfossology.h 
    DESTINATION ${FO_INCLUDEDIR}
    COMPONENT lib)
