cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(fossologyPHP)

# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)
endif()

foreach(PHP_GEN bootstrap.php services.xml)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${PHP_GEN}.in
        ${CMAKE_CURRENT_BINARY_DIR}/gen/${PHP_GEN})
endforeach()

install(DIRECTORY ./ ${CMAKE_CURRENT_BINARY_DIR}/gen/
    DESTINATION ${FO_MODDIR}/lib/php
    COMPONENT lib
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.twig
)
