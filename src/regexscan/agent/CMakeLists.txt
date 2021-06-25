
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS}")
include(FindPkgConfig)
include(FindPostgreSQL)
pkg_check_modules(GLIB REQUIRED glib-2.0)

include_directories(
    ${GLIB_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
)
if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

add_executable(regexscan "")
target_sources(regexscan PRIVATE ${FO_CWD}/regexscan.c)
target_compile_definitions(regexscan PRIVATE _FILE_OFFSET_BITS=64)
target_link_libraries(regexscan PRIVATE fossology)


install(TARGETS regexscan
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT regexscan)

# TODO: add VERSION and COMMIT ID 
# ASK: -Werror agents gives error?