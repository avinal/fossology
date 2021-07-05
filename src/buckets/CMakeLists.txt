cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(buckets LANGUAGES C)

# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)
generate_version()
install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT buckets
    FILES_MATCHING 
    PATTERN *.php)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/VERSION" buckets.conf 
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT buckets)

add_symlink()