set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})


if(NOT TARGET fodbreposysconf)
    add_subdirectory(${FO_TESTDIR}/db/c ctestdb EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET focunit)
    add_subdirectory(${FO_TESTDIR}/lib/c ctestlib EXCLUDE_FROM_ALL)
endif()


add_executable(test_libcpp "")
target_sources(test_libcpp 
    PRIVATE 
    ${FO_CWD}/run_tests.cc
    ${FO_CWD}/test_fossdbmanagerclass.cc)

target_include_directories(test_libcpp PRIVATE ${FO_TESTDIR}/db/c)
target_link_libraries(test_libcpp PRIVATE
    fossologyCPP cppunit fodbreposysconf)
add_test(cpplib_tests test_libcpp)
