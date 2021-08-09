set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})


if(NOT TARGET fodbreposysconf)
    add_subdirectory(${FO_TESTDIR}/db/c ctestdb EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET focunit)
    add_subdirectory(${FO_TESTDIR}/lib/c ctestlib EXCLUDE_FROM_ALL)
endif()

file(COPY confdata DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

add_executable(testlibs "")
target_sources(testlibs 
    PRIVATE 
    ${FO_CWD}/testlibs.c
    ${FO_CWD}/test_fossconfig.c
    ${FO_CWD}/test_fossscheduler.c
    ${FO_CWD}/test_libfossdb.c
    ${FO_CWD}/test_libfossdbmanager.c)
target_compile_definitions(testlibs PRIVATE CU_VERSION_P=213)
target_include_directories(testlibs PRIVATE 
${FO_TESTDIR}/lib/c ${FO_TESTDIR}/db/c)
target_link_libraries(testlibs PRIVATE
    fossology cunit fodbreposysconf focunit)
add_test(clib_tests testlibs)
