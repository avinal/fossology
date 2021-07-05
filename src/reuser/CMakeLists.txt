cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(reuser)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)
generate_version()
install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT reuser
    FILES_MATCHING
    PATTERN *.php
)

install(FILES reuser.conf "${CMAKE_CURRENT_BINARY_DIR}/VERSION"
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT reuser)

add_symlink()