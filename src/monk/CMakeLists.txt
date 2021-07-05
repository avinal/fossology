cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(monk LANGUAGES C)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)

install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT monk
    FILES_MATCHING
    PATTERN *.php
    PATTERN "agent-monk-bulk.php" EXCLUDE
)
install(FILES ui/agent-monk-bulk.php 
    DESTINATION ${FO_MODDIR}/monkbulk/ui
    COMPONENT monk)

foreach(MONK_INSTALL monkbulk monk)
    set(PROJECT_NAME ${MONK_INSTALL})
    configure_file("${FO_CMAKEDIR}/VERSION.in" 
        "${CMAKE_CURRENT_BINARY_DIR}/${MONK_INSTALL}/VERSION"
        NEWLINE_STYLE UNIX
        @ONLY)
    install(FILES ${MONK_INSTALL}.conf "${CMAKE_CURRENT_BINARY_DIR}/${MONK_INSTALL}/VERSION"
        DESTINATION ${FO_MODDIR}/${MONK_INSTALL}
        COMPONENT monk)
    add_symlink(${FO_MODDIR}/${MONK_INSTALL})
endforeach()

generate_version()
