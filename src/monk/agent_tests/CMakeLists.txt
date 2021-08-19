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

if(NOT TARGET fodbreposysconf)
    add_subdirectory(${FO_TESTDIR}/db/c ctestdb EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET focunit)
    add_subdirectory(${FO_TESTDIR}/lib/c ctestlib EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET phpunit)
    prepare_phpunit()
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS} -std=c99 -Wextra -fopenmp")

add_executable(test_monk "")
target_sources(test_monk 
    PRIVATE 
    ${FO_CWD}/Unit/run_tests.c
    ${FO_CWD}/Unit/test_string_operations.c
    ${FO_CWD}/Unit/test_file_operations.c
    ${FO_CWD}/Unit/test_license.c
    ${FO_CWD}/Unit/test_highlight.c
    ${FO_CWD}/Unit/test_hash.c
    ${FO_CWD}/Unit/test_match.c
    ${FO_CWD}/Unit/test_diff.c
    ${FO_CWD}/Unit/test_database.c
    ${FO_CWD}/Unit/test_encoding.c
    ${FO_CWD}/Unit/test_serialize.c)
target_compile_definitions(test_monk 
    PRIVATE _FILE_OFFSET_BITS=64 CU_VERSION_P=213 AGENT_DIR="${CMAKE_CURRENT_BINARY_DIR}/..")
target_include_directories(test_monk 
    PRIVATE ${FO_TESTDIR}/lib/c ${FO_TESTDIR}/db/c ${glib_INCLUDE_DIRS}
        ${PostgreSQL_INCLUDE_DIRS} ${FO_CLIB_SRC} ${FO_CWD}/../agent)
target_link_libraries(test_monk PRIVATE cunit fodbreposysconf focunit monk)

add_test(monk_unit_test test_monk)

add_test(NAME monk_functional_scheduler_test
    COMMAND ${PHPUNIT} --log-junit monk-Xunit1.xml --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Functional/schedulerTest.php)

add_test(NAME monk_functional_cli_test
    COMMAND ${PHPUNIT} --log-junit monk-Xunit2.xml --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Functional/cliTest.php)
    
add_test(NAME monk_functional_bulk_test
    COMMAND ${PHPUNIT} --log-junit monk-Xunit3.xml --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Functional/bulkTest.php)
