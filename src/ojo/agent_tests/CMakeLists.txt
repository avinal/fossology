set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -Wall")

add_executable(test_ojo "")
target_sources(test_ojo 
    PRIVATE 
    ${FO_CWD}/Unit/run_tests.cc
    ${FO_CWD}/Unit/test_regex.cc
    ${FO_CWD}/Unit/test_scanners.cc)
target_compile_definitions(test_ojo PRIVATE _FILE_OFFSET_BITS=64)
target_include_directories(test_ojo PRIVATE 
${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS} ${FO_CXXLIB_SRC} ${FO_CLIB_SRC} ${FO_CWD}/../agent)
target_link_libraries(test_ojo PRIVATE cppunit ojo boost_regex fossologyCPP icuuc)
add_test(ojo_unit_test test_ojo)
add_test(NAME ojo_functional_test_1
COMMAND ${PHPUNIT} --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Functional/schedulerTest.php)
add_test(NAME ojo_functional_test_2
COMMAND ${FO_CWD}/Functional/shunit2 ${FO_CWD}/Functional/cli_test.sh
    WORKING_DIRECTORY ${FO_CWD}/Functional)
