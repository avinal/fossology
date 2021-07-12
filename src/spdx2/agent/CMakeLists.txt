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

generate_version_php()

install(DIRECTORY ./ ${CMAKE_CURRENT_BINARY_DIR}/gen/ 
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent
    COMPONENT spdx2
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.twig
)

foreach(SPDX_INSTALL spdx2 spdx2tv dep5)
    install(FILES agent.sh
        DESTINATION ${FO_MODDIR}/${SPDX_INSTALL}/agent
        RENAME ${SPDX_INSTALL}.sh
        COMPONENT spdx2
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE)
endforeach()

add_symlink(${FO_LIBEXECDIR}/fo_wrapper ${PROJECT_NAME} ${FO_MODDIR}/${PROJECT_NAME}/agent)
