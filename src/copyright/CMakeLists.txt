cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(copyright LANGUAGES CXX)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)

install(DIRECTORY ui ui/template
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT copyright
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.twig
    PATTERN "agent-ecc.php" EXCLUDE
    PATTERN "agent-keyword.php" EXCLUDE)

foreach(COP ecc keyword copyright)
    set(PROJECT_NAME ${COP})
    generate_version(${COP} "VERSION-${COP}")
    install(FILES ui/agent-${COP}.php
        DESTINATION ${FO_MODDIR}/${COP}/ui
        COMPONENT ${COP})
    install(FILES ${COP}.conf "${CMAKE_CURRENT_BINARY_DIR}/VERSION-${COP}"
        DESTINATION ${FO_MODDIR}/${COP}
        COMPONENT ${COP})
    add_symlink(${FO_MODDIR}/${COP})
endforeach()
