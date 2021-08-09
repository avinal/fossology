set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})


if(NOT TARGET fodbreposysconf)
    add_subdirectory(${FO_TESTDIR}/db/c ctestdb EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET focunit)
    add_subdirectory(${FO_TESTDIR}/lib/c ctestlib EXCLUDE_FROM_ALL)
endif()

include_directories(
${FO_TESTDIR}/lib/c ${FO_TESTDIR}/db/c ${FO_CWD}/../agent ${glib_INCLUDE_DIRS}
${PostgreSQL_INCLUDE_DIRS} ${FO_CWD}/Unit ${FO_CLIB_SRC})

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

target_link_libraries(test_ununpack PRIVATE
    cunit fodbreposysconf focunit ununpack magic)
add_test(ununpack_unit_test test_ununpack)
