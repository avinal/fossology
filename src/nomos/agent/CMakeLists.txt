
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${FO_C_FLAGS}")

include_directories(
    ${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
)
if(NOT TARGET fossology)
    add_subdirectory(${FO_CLIB_SRC} buildc EXCLUDE_FROM_ALL)
endif()

add_executable(encode ${FO_CWD}/encode.c)

add_custom_command(
    OUTPUT _autodefs.h _autodata.c
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${FO_CWD}/generator $<TARGET_FILE_DIR:encode>
    COMMAND echo "NOTE: GENSEARCHDATA takes 1-2 minutes to run"
    COMMAND $<TARGET_FILE_DIR:encode>/GENSEARCHDATA
    WORKING_DIRECTORY $<TARGET_FILE_DIR:encode>
    DEPENDS encode
)

add_custom_command(
    OUTPUT _precheck.c
    COMMAND $<TARGET_FILE_DIR:encode>/PRECHECK
    COMMAND $<TARGET_FILE_DIR:encode>/CHECKSTR
    WORKING_DIRECTORY $<TARGET_FILE_DIR:encode>
    DEPENDS $<TARGET_FILE_DIR:encode>/_autodata.c
)

add_library(nomos "")
add_library(nomos_cov EXCLUDE_FROM_ALL "")
add_executable(nomos_exec "")
add_executable(nomos_cov_exec EXCLUDE_FROM_ALL "")

foreach(FO_NOM_TARGET nomos nomos_cov nomos_exec nomos_cov_exec)
    target_sources(${FO_NOM_TARGET}
        PRIVATE
        ${FO_CWD}/nomos.c
        ${FO_CWD}/licenses.c
        ${FO_CWD}/list.c
        ${FO_CWD}/parse.c
        ${FO_CWD}/process.c
        ${FO_CWD}/nomos_regex.c
        ${FO_CWD}/util.c
        ${FO_CWD}/nomos_gap.c
        ${FO_CWD}/nomos_utils.c
        ${FO_CWD}/doctorBuffer_utils.c
        ${FO_CWD}/json_writer.c
        ${FO_CWD}/nomos.h
        ${FO_CWD}/licenses.h
        ${FO_CWD}/list.h
        ${FO_CWD}/parse.h
        ${FO_CWD}/process.h
        ${FO_CWD}/nomos_regex.h
        ${FO_CWD}/util.h
        ${FO_CWD}/nomos_gap.h
        ${FO_CWD}/nomos_utils.h
        ${FO_CWD}/doctorBuffer_utils.h
        ${FO_CWD}/json_writer.h
        $<TARGET_FILE_DIR:encode>/_autodefs.h
        $<TARGET_FILE_DIR:encode>/_autodata.c
        $<TARGET_FILE_DIR:encode>/_precheck.c
    )
    target_compile_definitions(${FO_NOM_TARGET} 
        PRIVATE 
        _FILE_OFFSET_BITS=64
        VERSION_S="${FO_VERSION}"
        COMMIT_HASH_S="${FO_COMMIT_HASH}")
    target_include_directories(${FO_NOM_TARGET}
        PRIVATE $<TARGET_FILE_DIR:encode> ${FO_CWD})
    if(${FO_NOM_TARGET} MATCHES "cov")
        target_compile_options(${FO_NOM_TARGET} PRIVATE ${FO_COV_FLAGS})
    endif()
    if(${FO_NOM_TARGET} MATCHES "_exec$")
        target_link_libraries(${FO_NOM_TARGET} 
            PRIVATE 
            fossology
            ${jsonc_LIBRARIES}
            pthread
            rt
        )
        string(REPLACE "_exec" "" FO_NOM_TARGET_R ${FO_NOM_TARGET})
        set_target_properties(${FO_NOM_TARGET}
            PROPERTIES OUTPUT_NAME ${FO_NOM_TARGET_R})
        # HACK: add dependency of executable on libraries to force sequence
        add_dependencies(${FO_NOM_TARGET} ${FO_NOM_TARGET_R}) 
    endif()
endforeach()

install(TARGETS nomos_exec
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT nomos)

# FIXME: nomos coverage not building
