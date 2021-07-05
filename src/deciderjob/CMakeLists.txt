cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(deciderjob)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)
generate_version()

install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT deciderjob
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.twig
)

install(FILES deciderjob.conf "${CMAKE_CURRENT_BINARY_DIR}/VERSION"
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT deciderjob)

add_symlink()