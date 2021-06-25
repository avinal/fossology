cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(buckets LANGUAGES C)

# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)
configure_file("${FO_CMAKEDIR}/VERSION.in" 
    "${CMAKE_CURRENT_BINARY_DIR}/VERSION"
    NEWLINE_STYLE UNIX
    @ONLY)
install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT buckets
    FILES_MATCHING 
    PATTERN *.php)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/VERSION" buckets.conf 
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT buckets)