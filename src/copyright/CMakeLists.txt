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
project(copyright LANGUAGES CXX)

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)

if(TESTING)
    enable_testing()
    add_subdirectory(agent_tests)
endif()
install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT copyright
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.twig
    PATTERN "agent-ecc.php" EXCLUDE
    PATTERN "agent-keyword.php" EXCLUDE)

foreach(COP ecc keyword copyright)
    set(PROJECT_NAME ${COP})
    generate_version(${COP} "VERSION-${COP}")
    install(FILES ui/agent-${COP}.php
        DESTINATION ${FO_MODDIR}/${COP}/ui
        COMPONENT ${COP})
    install(FILES ${COP}.conf
        DESTINATION ${FO_MODDIR}/${COP}
        COMPONENT ${COP})
    install(FILES "${CMAKE_CURRENT_BINARY_DIR}/VERSION-${COP}"
        DESTINATION ${FO_MODDIR}/${COP}
        RENAME "VERSION"
        COMPONENT ${COP})
    add_symlink(${COP})
endforeach()
