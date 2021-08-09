if(NOT TARGET phpunit)
    prepare_phpunit()
endif()

add_test(NAME decider_unit_test
    COMMAND ${PHPUNIT} --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Unit/DeciderAgentTest.php)

add_test(NAME decider_functional_test
    COMMAND ${PHPUNIT} --bootstrap ${PHPUNIT_BOOTSTRAP} ${CMAKE_CURRENT_LIST_DIR}/Functional/schedulerTest.php)