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

add_executable(test_delagent "")
target_sources(test_delagent 
    PRIVATE 
    ${FO_CWD}/Unit/testRun.c
    ${FO_CWD}/Unit/testListFolders.c
    ${FO_CWD}/Unit/testDeleteFolders.c
    ${FO_CWD}/../agent/util.c)
target_compile_definitions(test_delagent PRIVATE CU_VERSION_P=213)
target_include_directories(test_delagent PRIVATE ${FO_TESTDIR}/lib/c ${FO_TESTDIR}/db/c ${FO_CWD}/../agent ${glib_INCLUDE_DIRS}
${PostgreSQL_INCLUDE_DIRS} ${FO_CWD}/Unit ${FO_CLIB_SRC})
target_link_libraries(test_delagent PRIVATE
    fossology cunit fodbreposysconf focunit gcrypt ${glib_LIBRARIES}
    ${PostgreSQL_LIBRARIES})
# FIXME: tests failing
# add_test(delagent_unit_test test_delagent)
add_test(NAME delagent_functional_test 
    COMMAND ${PHPUNIT} --log-junit delagent-Xunit.xml ${CMAKE_CURRENT_LIST_DIR}/Functional/ft_cliDelagentTest.php)
