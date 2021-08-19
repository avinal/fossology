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

if(NOT TARGET phpunit)
    prepare_phpunit()
endif()

add_executable(test_libcpp "")
target_sources(test_libcpp PRIVATE ${FO_CWD}/run_tests.cc ${FO_CWD}/test_fossdbmanagerclass.cc)
target_include_directories(test_libcpp PRIVATE ${FO_TESTDIR}/db/c)
target_compile_definitions(test_libcpp PRIVATE BUILDDIR="${FO_SOURCEDIR}/../build")
target_link_libraries(test_libcpp PRIVATE fossologyCPP cppunit fodbreposysconf)

add_test(cpplib_tests test_libcpp)
