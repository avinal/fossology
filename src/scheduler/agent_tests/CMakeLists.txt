set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

if(NOT TARGET fodbreposysconf)
    add_subdirectory(${FO_TESTDIR}/db/c ctestdb EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET focunit)
    add_subdirectory(${FO_TESTDIR}/lib/c ctestlib EXCLUDE_FROM_ALL)
endif()
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")

add_compile_definitions(
    LOG_DIR="${FO_LOGDIR}"
    FOSSDB_CONF="${FO_SYSCONFDIR}/Db.conf"
    PROJECT_USER="${FO_PROJECTUSER}"
    PROJECT_GROUP="${FO_PROJECTGROUP}"
    CLI_DIR="${FO_DESTDIR}${FO_BINDIR}"
    DEFAULT_SETUP="${FO_SYSCONFDIR}"
    _FILE_OFFSET_BITS=64
    PROCESS_NAME="test_scheduler")

add_executable(test_scheduler "")
target_sources(test_scheduler 
    PRIVATE 
    ${FO_CWD}/Unit/testRun.c
    ${FO_CWD}/Unit/testHost.c
    ${FO_CWD}/Unit/testInterface.c
    ${FO_CWD}/Unit/testAgent.c
    ${FO_CWD}/Unit/testEvent.c
    ${FO_CWD}/Unit/testDatabase.c
    ${FO_CWD}/Unit/testScheduler.c
    ${FO_CWD}/Unit/testJob.c
    ${FO_CWD}/Unit/utils.c)
target_compile_definitions(test_scheduler PRIVATE _FILE_OFFSET_BITS=64 CU_VERSION_P=213)
target_include_directories(test_scheduler PRIVATE 
${FO_TESTDIR}/lib/c ${FO_TESTDIR}/db/c
${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS} ${FO_CLIB_SRC} ${FO_CWD}/../agent ${FO_CWD}/Unit)
target_link_libraries(test_scheduler PRIVATE
    cunit focunit scheduler fodbreposysconf pcre)
add_test(scheduler_unit_test test_scheduler)
