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

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -fopenmp -Wextra")

add_executable(test_copyright "")
target_sources(test_copyright
    PRIVATE
        ${FO_CWD}/Unit/run_tests.cc
        ${FO_CWD}/Unit/test_regex.cc
        ${FO_CWD}/Unit/test_scanners.cc
        ${FO_CWD}/Unit/test_regexConfProvider.cc)
target_link_libraries(test_copyright PRIVATE copyright_lib dl cppunit)
target_include_directories(test_copyright 
    PRIVATE ${FO_CWD}/../agent ${glib_INCLUDE_DIRS} ${jsoncpp_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS} ${FO_CLIB_SRC} ${FO_CXXLIB_SRC})

add_test(copyright_unit_test test_copyright)

add_test(NAME copyright_functional_cli_test 
    COMMAND bash ${FO_CWD}/Functional/shunit2 ${FO_CWD}/Functional/cli_test.sh
    WORKING_DIRECTORY ${FO_CWD}/Functional)

add_test(NAME copyright_functional_scheduler_test
    COMMAND ${PHPUNIT} --bootstrap ${PHPUNIT_BOOTSTRAP}  ${FO_CWD}/Functional/schedulerTest.php)
