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

#[[
if(NOT TARGET fodbreposysconf)
    add_subdirectory(${FO_TESTDIR}/db/c ctestdb EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET focunit)
    add_subdirectory(${FO_TESTDIR}/lib/c ctestlib EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET phpunit)
    prepare_phpunit()
endif()
#]]

file(COPY testdata DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

foreach(TEST_FILES "fossI16L335U29.tar.bz2" "fossI16L518.7z")
	file(COPY ${FO_TESTDIR}/dataFiles/TestData/archives/${TEST_FILES} 
		DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/testdata/)
endforeach()

#[[ FIXME: Unit tests failing
add_executable(test_ununpack "")
target_sources(test_ununpack 
    PRIVATE 
        ${FO_CWD}/Unit/run_tests.c
		${FO_CWD}/Unit/test_CopyFile.c
		${FO_CWD}/Unit/test_FindCmd.c
		${FO_CWD}/Unit/test_Prune.c
		${FO_CWD}/Unit/test_RunCommand.c
		${FO_CWD}/Unit/test_Traverse.c
		${FO_CWD}/Unit/test_ununpack-ar.c
		${FO_CWD}/Unit/test_TraverseChild.c
		${FO_CWD}/Unit/test_TraverseStart.c
		${FO_CWD}/Unit/test_ununpack-disk.c
		${FO_CWD}/Unit/test_ununpack-iso.c
		${FO_CWD}/Unit/test_TaintString.c
		${FO_CWD}/Unit/test_IsFunctions.c
		${FO_CWD}/Unit/test_ContainerInfo.c
		${FO_CWD}/Unit/test_Checksum.c
		${FO_CWD}/Unit/test_PathCheck.c
		${FO_CWD}/Unit/test_DBInsert.c)
target_compile_definitions(test_ununpack PRIVATE CU_VERSION_P=213)
target_include_directories(test_ununpack 
	PRIVATE ${FO_TESTDIR}/lib/c ${FO_TESTDIR}/db/c ${FO_CWD}/../agent 
	${glib_INCLUDE_DIRS} ${PostgreSQL_INCLUDE_DIRS} ${FO_CWD}/Unit ${FO_CLIB_SRC})
target_link_libraries(test_ununpack PRIVATE cunit fodbreposysconf focunit ununpack magic)

add_test(ununpack_unit_test test_ununpack)
#]]

add_custom_target(testUnpack ALL
	COMMAND tar -xvjf testdata.tar.bz2
	COMMENT "Unpacking archive for test"
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/testdata)

add_test(NAME ununpack_functional_test
    COMMAND ${PHPUNIT} --log-junit ${CMAKE_CURRENT_BINARY_DIR}/ununpack-Xunit.xml --configuration ${FO_CWD}/Functional/tests.xml
    WORKING_DIRECTORY ${FO_CWD})
