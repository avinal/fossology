set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

if(NOT TARGET fodbreposysconf)
    add_subdirectory(${FO_TESTDIR}/db/c ctestdb EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET focunit)
    add_subdirectory(${FO_TESTDIR}/lib/c ctestlib EXCLUDE_FROM_ALL)
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
target_compile_definitions(test_monk PRIVATE _FILE_OFFSET_BITS=64 CU_VERSION_P=213)
target_include_directories(test_monk PRIVATE 
${FO_TESTDIR}/lib/c ${FO_TESTDIR}/db/c
${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS} ${FO_CLIB_SRC} ${FO_CWD}/../agent)
target_link_libraries(test_monk PRIVATE cunit fodbreposysconf focunit monk)
add_test(monk_unit_test test_monk)
