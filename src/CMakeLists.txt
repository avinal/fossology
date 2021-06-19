cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

add_subdirectory(lib)
add_subdirectory(scheduler)
add_subdirectory(adj2nest)
add_subdirectory(buckets)
add_subdirectory(copyright)
add_subdirectory(delagent)
add_subdirectory(maintagent)
add_subdirectory(mimetype)
add_subdirectory(pkgagent)
add_subdirectory(ojo)
add_subdirectory(regexscan)
add_subdirectory(nomos)
add_subdirectory(monk)
add_subdirectory(ununpack)
add_subdirectory(wget_agent)


# TODO: find alternative for add directories
