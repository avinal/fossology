cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(www)
# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT www
)
