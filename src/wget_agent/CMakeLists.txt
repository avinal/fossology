cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(wget_agent LANGUAGES C)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)
generate_version()
install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT wget_agent
    FILES_MATCHING
    PATTERN *.php
)

install(FILES wget_agent.conf mod_deps "${CMAKE_CURRENT_BINARY_DIR}/VERSION"
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT wget_agent)

add_symlink()