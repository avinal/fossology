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

add_executable(test_nomos "")
target_sources(test_nomos 
    PRIVATE 
    ${FO_CWD}/Unit/run_tests.c
    ${FO_CWD}/Unit/test_DoctoredBuffer.c
    ${FO_CWD}/Unit/test_nomos_gap.c)
target_compile_definitions(test_nomos 
    PRIVATE _FILE_OFFSET_BITS=64 CU_VERSION_P=213 
        TESTDATADIR="${FO_SOURCEDIR}/nomos/agent_tests/testdata")
target_include_directories(test_nomos 
    PRIVATE ${FO_TESTDIR}/lib/c ${FO_TESTDIR}/db/c ${glib_INCLUDE_DIRS} 
        $<TARGET_FILE_DIR:encode> ${PostgreSQL_INCLUDE_DIRS} ${FO_CLIB_SRC} ${FO_CWD}/../agent)
target_link_libraries(test_nomos PRIVATE cunit focunit nomos)

add_test(nomos_unit_test test_nomos)

add_test(NAME nomos_functional_test
    COMMAND ${PHPUNIT} --log-junit nomos-Xunit.xml --configuration ${FO_CWD}/Functional/tests.xml)
    