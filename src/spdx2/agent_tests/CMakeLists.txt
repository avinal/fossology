if(NOT TARGET phpunit)
    prepare_phpunit()
endif()

add_test(NAME spdx2_unit_test
    COMMAND ${PHPUNIT} --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Unit/spdx2utilTest.php)

add_test(NAME spdx2_functional_test
    COMMAND ${PHPUNIT} --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Functional/schedulerTest.php)