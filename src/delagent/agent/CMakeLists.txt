

set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS} -fPIC")
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

add_executable(delagent "")
target_sources(delagent
    PRIVATE
    ${FO_CWD}/delagent.c
    ${FO_CWD}/delagent.h
    ${FO_CWD}/util.c
)
target_compile_definitions(delagent PRIVATE _FILE_OFFSET_BITS=64)
target_link_libraries(delagent PRIVATE fossology gcrypt)

install(TARGETS delagent
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT delagent)
