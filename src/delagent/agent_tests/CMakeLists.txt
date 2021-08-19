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

if(NOT TARGET phpunit)
    prepare_phpunit()
endif()

if(NOT TARGET fodbreposysconf)
    add_subdirectory(${FO_TESTDIR}/db/c ctestdb EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET focunit)
    add_subdirectory(${FO_TESTDIR}/lib/c ctestlib EXCLUDE_FROM_ALL)
endif()

file(COPY testdata ${FO_CWD}/Unit/testInitDB.sh ${FO_CWD}/Unit/testInitRepo.sh
    DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/testconf)
add_executable(test_delagent "")
target_sources(test_delagent 
    PRIVATE 
    ${FO_CWD}/Unit/testRun.c
    ${FO_CWD}/Unit/testListFolders.c
    ${FO_CWD}/Unit/testDeleteFolders.c
    ${FO_CWD}/../agent/util.c)
target_compile_definitions(test_delagent PRIVATE CU_VERSION_P=213 AGENT_DIR="${CMAKE_CURRENT_BINARY_DIR}/..")
target_include_directories(test_delagent 
    PRIVATE ${FO_TESTDIR}/lib/c ${FO_TESTDIR}/db/c ${FO_CWD}/../agent 
    ${glib_INCLUDE_DIRS} ${PostgreSQL_INCLUDE_DIRS} ${FO_CWD}/Unit ${FO_CLIB_SRC})
target_link_libraries(test_delagent 
    PRIVATE fossology cunit fodbreposysconf focunit gcrypt 
    ${glib_LIBRARIES} ${PostgreSQL_LIBRARIES})

# FIXME: unit tests failing
add_test(delagent_unit_test test_delagent)

add_test(NAME delagent_functional_cli_test 
    COMMAND ${PHPUNIT} --log-junit delagent-Xunit.xml ${CMAKE_CURRENT_LIST_DIR}/Functional/ft_cliDelagentTest.php)
