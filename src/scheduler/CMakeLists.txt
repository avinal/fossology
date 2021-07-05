cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(scheduler LANGUAGES C)

# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)
generate_version()
install(FILES mod_deps "${CMAKE_CURRENT_BINARY_DIR}/VERSION"
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT scheduler)