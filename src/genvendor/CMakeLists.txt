cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(genvendor)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)

file(COPY composer.json composer.lock RdfXml.php.patch ComposerInstall
    DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/vendor)

add_custom_target(vendor ALL
    COMMAND ${CMAKE_CURRENT_BINARY_DIR}/vendor/ComposerInstall
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/vendor"
    COMMENT "Generating vendor"
    DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/vendor/ComposerInstall
    BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/vendor/vendor)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/vendor/
    DESTINATION ${FO_MODDIR}
    COMPONENT vendor
    PATTERN *.patch EXCLUDE
    PATTERN "ComposerInstall" EXCLUDE)

