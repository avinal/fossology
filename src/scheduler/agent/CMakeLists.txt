set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
add_compile_definitions(
    LOG_DIR="${FO_LOGDIR}"
    FOSSDB_CONF="${FO_SYSCONFDIR}/Db.conf"
    PROJECT_USER="${FO_PROJECTUSER}"
    PROJECT_GROUP="${FO_PROJECTGROUP}"
    CLI_DIR="${FO_DESTDIR}${FO_BINDIR}"
    DEFAULT_SETUP="${FO_SYSCONFDIR}"
    _FILE_OFFSET_BITS=64
)

if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

include_directories(
    ${FO_CWD}
    ${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
)

add_library(scheduler "")
add_library(scheduler_cov EXCLUDE_FROM_ALL "")
add_executable(fo_scheduler "")
add_executable(fo_cli "")

foreach(FO_SCH_TARGET scheduler fo_scheduler fo_cli scheduler_cov)
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
        # TODO: PROCESS_NAME is both exe at the same time
        target_compile_options(${FO_SCH_TARGET}
            PRIVATE "-DPROCESS_NAME=${FO_SCH_TARGET}")
    else()
        set(SCH_XSRC "")
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

target_compile_options(scheduler_cov PRIVATE ${FO_COV_FLAGS})

# HACK: adding target for angled branckes
target_include_directories(scheduler_cov PRIVATE ${FO_CWD})
target_include_directories(scheduler 
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>)

add_custom_target(initfile ALL
COMMAND ${CMAKE_COMMAND}
    -DIN_FILE_NAME="fossology.in"
    -DOUT_FILE_NAME="fossology"
    -DINPUT_FILE_DIR="${FO_CWD}/defconf/init.d"
    -DOUTPUT_FILE_DIR="${CMAKE_CURRENT_BINARY_DIR}/gen/init.d"
    -DFO_SYSCONFDIR="${FO_SYSCONFDIR}"
    -DFO_PROJECT="${FO_PROJECT}"
    -DFO_MODDIR="${FO_MODDIR}"
    -DFO_INITDIR="${FO_INITDIR}"
    -P ${FO_CMAKEDIR}/FoVersionFile.cmake
    COMMENT "Generating init script for the ${FO_PROJECT} scheduler"
    DEPENDS "${FO_CWD}/defconf/init.d/fossology.in"
    BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/gen/init.d)

install(TARGETS fo_cli fo_scheduler
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT scheduler)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/gen/init.d
    DESTINATION ${FO_INITDIR}
    COMPONENT scheduler) 
add_symlink()

# TODO: add install for configuration files
# ASK: what are the configuration files and how they are generared?