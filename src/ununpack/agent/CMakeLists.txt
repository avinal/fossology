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

set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS}")

include_directories(
    ${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC})

if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()
add_compile_definitions(
    _FILE_OFFSET_BITS=64
    VERSION_S="${FO_VERSION}"
    COMMIT_HASH_S="${FO_COMMIT_HASH}")

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
        ${FO_CWD}/checksum.c)
    target_link_libraries(${FO_UNP_LIB} PRIVATE fossology gcrypt)
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

install(TARGETS ununpack_exec departition
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT ununpack)
