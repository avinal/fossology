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

add_executable(test_wget_agent "")
target_sources(test_wget_agent 
    PRIVATE 
    ${FO_CWD}/Unit/testRun.c
    ${FO_CWD}/Unit/utility.c
    ${FO_CWD}/Unit/wget_agent/testGetURL.c
    ${FO_CWD}/Unit/wget_agent/testSetEnv.c
    ${FO_CWD}/Unit/wget_agent/testUtilities.c
    ${FO_CWD}/Unit/wget_agent/testDBLoadGold.c)
target_compile_definitions(test_wget_agent PRIVATE CU_VERSION_P=213)

target_link_libraries(test_wget_agent PRIVATE
    cunit fodbreposysconf focunit wget_agent)
add_test(test_wget_agent test_wget_agent)
