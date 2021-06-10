# set minimum cmake version required
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(schedular LANGUAGES C)

# set defaults
if(NOT DEFINED ARE_DEFAULTS_SET)
    include(${CMAKE_CURRENT_SOURCE_DIR}/../../../cmake/SetDefaults.cmake)
endif(NOT DEFINED ARE_DEFAULTS_SET)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC -Wall")
add_compile_definitions(
    LOG_DIR="${FO_LOGDIR}"
    FOSSDB_CONF="${FO_SYSCONFDIR}/${FO_PROJECT}/Db.conf"
    PROJECT_USER="${FO_PROJECTUSER}"
    PROJECT_GROUP="${FO_PROJECTGROUP}"
    CLI_DIR="${FO_DESTDIR}${FO_BINDIR}" 
    DEFAULT_SETUP="${FO_SYSCONFDIR}"
    _FILE_OFFSET_BITS=64
)

include(FindPkgConfig)
include(FindPostgreSQL)
foreach(SCHE_LIBS glib-2.0 gthread-2.0 gio-2.0 gobject-2.0)
    string(REPLACE "-2.0" "" LIB_NAME ${SCHE_LIBS})
    pkg_check_modules(${LIB_NAME} REQUIRED ${SCHE_LIBS})
endforeach()

if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

include_directories(
    ${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
)

add_library(scheduler "")
add_executable(fo_scheduler "")
add_executable(fo_cli "")
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
foreach(FO_SCH_TARGET scheduler fo_scheduler fo_cli)
    if(${FO_SCH_TARGET} MATCHES "^fo_")
        set(SCH_XSRC ${FO_SCH_TARGET}.c)
        target_link_libraries(${FO_SCH_TARGET}
            PRIVATE
                fossology 
                scheduler
                ${gobject_LIBRARIES}
                ${gthread_LIBRARIES}
                ${gio_LIBRARIES}
        )
        target_compile_options(${FO_SCH_TARGET}
            PRIVATE "-DPROCESS_NAME=${FO_SCH_TARGET}")
    endif() 
    target_sources(${FO_SCH_TARGET}
        PRIVATE
            ${FO_CWD}/scheduler.c
            ${FO_CWD}/event.c
            ${FO_CWD}/agent.c
            ${FO_CWD}/host.c
            ${FO_CWD}/database.c
            ${FO_CWD}/job.c
            ${FO_CWD}/logging.c
            ${FO_CWD}/emailformatter.c
            ${FO_CWD}/${SCH_XSRC}
            "${FO_CWD}/interface.c"
        PUBLIC
            ${FO_CWD}/scheduler.h
            ${FO_CWD}/event.h
            ${FO_CWD}/agent.h
            ${FO_CWD}/host.h
            ${FO_CWD}/database.h
            ${FO_CWD}/job.h
            ${FO_CWD}/logging.c
            ${FO_CWD}/emailformatter.c
            "${FO_CWD}/interface.h"
    )
endforeach()

target_include_directories(scheduler 
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>)
