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
project(cli)

set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})


include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)
file(GLOB CLI_FILES ${FO_CWD}/*.php)
list(REMOVE_ITEM CLI_FILES 
    "${FO_CWD}/acme_review.php" 
    "${FO_CWD}/fo_antelink.php" 
    "${FO_CWD}/fo_tagfile.php" 
    "${FO_CWD}/fo_tagfoss.php")

configure_file(${FO_CWD}/fo_wrapper.php.in
    ${CMAKE_CURRENT_BINARY_DIR}/gen/fo_wrapper.php
    NEWLINE_STYLE UNIX
    @ONLY)

add_custom_target(manfiles ALL
    COMMAND pod2man --center="${FO_CWD}/fossjobs" --release="Version ${FO_VERSION}" "${FO_CWD}/fossjobs.pod" > "${CMAKE_CURRENT_BINARY_DIR}/gen/fossjobs.1"
    COMMAND pod2man --center="${FO_CWD}/cp2foss" --release="Version ${FO_VERSION}" "${FO_CWD}/cp2foss.pod" > "${CMAKE_CURRENT_BINARY_DIR}/gen/cp2foss.1"
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Genetating manfiles"
    DEPENDS mkpod cp2foss.pod fossjobs.pod)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/gen/fo_wrapper.php
    DESTINATION ${FO_LIBEXECDIR}
    RENAME fo_wrapper
    COMPONENT cli
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE # ASK: which permission needed?
    )

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/gen/
    DESTINATION ${FO_MAN1DIR}
    COMPONENT cli
    FILES_MATCHING
    PATTERN *.1)
install(FILES ${CLI_FILES}
    DESTINATION ${FO_LIBEXECDIR}
    COMPONENT cli)

foreach(CLI_FILE ${CLI_FILES})
    get_filename_component(FILE_NAME ${CLI_FILE} NAME_WE)
    add_symlink(${FO_LIBEXECDIR}/fo_wrapper ${FILE_NAME} ${FO_BINDIR})
endforeach()
