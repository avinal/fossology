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
project(libphp)

include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)

foreach(PHP_GEN bootstrap.php services.xml)
    add_custom_target(${PHP_GEN} ALL
        COMMAND ${CMAKE_COMMAND}
        -DIN_FILE_NAME="${PHP_GEN}.in"
        -DOUT_FILE_NAME="${PHP_GEN}"
        -DINPUT_FILE_DIR="${CMAKE_CURRENT_SOURCE_DIR}"
        -DOUTPUT_FILE_DIR="${CMAKE_CURRENT_BINARY_DIR}/gen"
        -DFO_SYSCONFDIR="${FO_SYSCONFDIR}"
        -DFO_TWIG_CACHE="${FO_TWIG_CACHE}"
        -P ${FO_CMAKEDIR}/FoVersionFile.cmake
        COMMENT "Generating ${PHP_GEN}"
        DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${PHP_GEN}.in"
        BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/gen/${PHP_GEN}")
endforeach()
 
install(DIRECTORY ./ ${CMAKE_CURRENT_BINARY_DIR}/gen/
    DESTINATION ${FO_MODDIR}/lib/php
    COMPONENT lib
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.twig
    PATTERN *.xml
    REGEX "\/tests" EXCLUDE
    REGEX "\/test" EXCLUDE)
