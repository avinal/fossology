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
project(www)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/gen/fossology.rc "${FO_SYSCONFDIR}")

install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT www
    PATTERN "pretty-swag.json" EXCLUDE)

install(FILES 
    ${CMAKE_CURRENT_BINARY_DIR}/gen/fossology.rc 
    ${FO_SOURCEDIR}/../NOTICES-THIRDPARTY.html
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/ui
    COMPONENT www)

add_custom_target(www ALL
    COMMENT "Configuring www for symbolic link")
add_symlink()
foreach(WWW_INSTALL page async)
    add_symlink(www-${WWW_INSTALL} ${FO_MODDIR}/${PROJECT_NAME}/ui/${WWW_INSTALL})
endforeach()
