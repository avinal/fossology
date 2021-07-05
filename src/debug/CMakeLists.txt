cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(debug)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)

install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT debug
    FILES_MATCHING
    PATTERN *.php
)
add_symlink()
