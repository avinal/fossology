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
project(softwareHeritage)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)
generate_version()
install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT softwareHeritage
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.twig
)

install(FILES softwareHeritage.conf "${CMAKE_CURRENT_BINARY_DIR}/VERSION"
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT softwareHeritage)

add_symlink()
