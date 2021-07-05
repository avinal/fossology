cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(delagent LANGUAGES C)

# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)
generate_version()

install(DIRECTORY ui ui/template ui/Page
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT delagent
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.twig
    )

install(FILES delagent.conf mod_deps "${CMAKE_CURRENT_BINARY_DIR}/VERSION"
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT delagent)

add_symlink()
add_symlink(${FO_MODDIR}/${PROJECT_NAME}/ui/Page ${PROJECT_NAME}-page)
   