# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(fossology LANGUAGES C)

# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -Wall")
add_compile_definitions(
    FOSSDB_CONF="${FO_SYSCONFDIR}/Db.conf"
    FOSSGROUP="${FO_PROJECTGROUP}" 
    DEFAULT_SETUP="${FO_SYSCONFDIR}"
    _FILE_OFFSET_BITS=64
)

include(FindPkgConfig)
include(FindPostgreSQL)
pkg_check_modules(GLIB REQUIRED glib-2.0)

include_directories(
    ${fossology_SOURCE_DIR}
    ${GLIB_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
)

add_library(fossology "")
add_library(fossology_cov EXCLUDE_FROM_ALL "")
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
foreach(FO_CLIB_TARGET fossology fossology_cov)
    target_sources(${FO_CLIB_TARGET}
        PRIVATE
            ${FO_CWD}/libfossscheduler.c
            ${FO_CWD}/libfossdb.c
            ${FO_CWD}/libfossagent.c
            ${FO_CWD}/libfossrepo.c
            ${FO_CWD}/libfossdbmanager.c
            ${FO_CWD}/fossconfig.c
            ${FO_CWD}/sqlCopy.c
        PUBLIC
            ${FO_CWD}/libfossscheduler.h
            ${FO_CWD}/libfossdb.h
            ${FO_CWD}/libfossagent.h
            ${FO_CWD}/libfossrepo.h
            ${FO_CWD}/libfossdbmanager.h
            ${FO_CWD}/fossconfig.h
            ${FO_CWD}/sqlCopy.h
    )

    target_link_libraries(${FO_CLIB_TARGET}
        PRIVATE ${GLIB_LIBRARIES} ${PostgreSQL_LIBRARIES})
endforeach()

target_compile_options(fossology_cov PRIVATE ${FO_COV_FLAGS})

foreach(FO_CLIB_EXEC sqlCopyTest fossconfigTest reppath)
    add_executable(${FO_CLIB_EXEC} "")
    target_sources(${FO_CLIB_EXEC} PRIVATE ${FO_CLIB_EXEC}.c)
    target_link_libraries(${FO_CLIB_EXEC} PRIVATE fossology)
endforeach()

target_include_directories(fossology 
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>)

install(TARGETS fossology sqlCopyTest fossconfigTest reppath 
    RUNTIME DESTINATION ${FO_LIBEXECDIR}
    ARCHIVE DESTINATION ${FO_LIBEXECDIR}
    COMPONENT lib)
