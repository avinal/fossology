set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS}")
include(FindPkgConfig)
include(FindPostgreSQL)
pkg_check_modules(GLIB REQUIRED glib-2.0)

include_directories(
    ${GLIB_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
)
if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

add_executable(buckets "")
target_sources(buckets
    PRIVATE
    ${FO_CWD}/buckets.c
    ${FO_CWD}/validate.c
    ${FO_CWD}/inits.c
    ${FO_CWD}/liccache.c
    ${FO_CWD}/walk.c
    ${FO_CWD}/leaf.c
    ${FO_CWD}/match.c
    ${FO_CWD}/container.c
    ${FO_CWD}/child.c
    ${FO_CWD}/write.c
    ${FO_CWD}/liccache.h
    ${FO_CWD}/buckets.h
)
target_compile_definitions(buckets
    PRIVATE
    _FILE_OFFSET_BITS=64
    PROJECTSTATEDIR="${FO_PROJECTSTATEDIR}"
    DATADIR="${FO_DATADIR}"
)
target_link_libraries(buckets PRIVATE fossology)

install(TARGETS buckets
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT buckets)

# TODO: add VERSION and COMMIT ID 