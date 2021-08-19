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

if(NOT TARGET phpunit)
    prepare_phpunit()
endif()

add_custom_target(prepare_spdx2_test ALL
    COMMENT "Preparing spdx2 test"
    COMMAND ln -sf "${CMAKE_CURRENT_BINARY_DIR}/../VERSION"
    COMMAND ln -sf "${FO_WRAPPER}" "${CMAKE_CURRENT_SOURCE_DIR}/../agent/spdx2"
    COMMAND ln -sf "${CMAKE_CURRENT_BINARY_DIR}/../agent/gen/version.php" "${CMAKE_CURRENT_SOURCE_DIR}/../agent/version.php"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/..)

add_test(NAME spdx2_unit_test
    COMMAND ${PHPUNIT} --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Unit/spdx2utilTest.php)

add_test(NAME spdx2_functional_scheduler_test
    COMMAND ${PHPUNIT} --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Functional/schedulerTest.php)
