
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS}")
include(FindPkgConfig)
include(FindPostgreSQL)
pkg_check_modules(GLIB REQUIRED glib-2.0)

include_directories(
    ${GLIB_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    /usr/include/rpm
)
if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

add_executable(pkgagent "")
target_sources(pkgagent
    PRIVATE
    ${FO_CWD}/main.c
    ${FO_CWD}/pkgagent.c
    ${FO_CWD}/pkgagent.h
)
target_compile_definitions(pkgagent PRIVATE _FILE_OFFSET_BITS=64)
target_link_libraries(pkgagent PRIVATE fossology rpm rpmio)

install(TARGETS pkgagent
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT pkgagent-agent)

# TODO: add VERSION and COMMIT ID 