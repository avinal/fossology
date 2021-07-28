set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -fopenmp -Wextra")
add_executable(test_copyright EXCLUDE_FROM_ALL "")
# ASK: do test should built as default?
target_sources(test_copyright
    PRIVATE
        ${FO_CWD}/Unit/run_tests.cc
        ${FO_CWD}/Unit/test_regex.cc
        ${FO_CWD}/Unit/test_scanners.cc
        ${FO_CWD}/Unit/test_regexConfProvider.cc)
target_link_libraries(test_copyright
    PRIVATE fossologyCPP m icuuc icudata stdc++
    ${Boost_LIBRARIES} ${jsoncpp_LIBRARIES} copyright_lib dl cppunit)
target_include_directories(test_copyright PRIVATE ${FO_CWD}/../agent
${glib_INCLUDE_DIRS}
    ${jsoncpp_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC})
add_test(copyright_unit_tests test_copyright)
add_test(NAME copyright_functional_tests 
    COMMAND bash ${FO_CWD}/Functional/shunit2 ${FO_CWD}/Functional/cli_test.sh
    WORKING_DIRECTORY ${FO_CWD}/Functional)
# ASK: tests will only work with make all test 
add_custom_target(check
    COMMAND ${CMAKE_CTEST_COMMAND}
    DEPENDS test_copyright)

# TODO: php tests

