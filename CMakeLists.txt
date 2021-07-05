# Top level CMake configuration
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(FOSSOLOGY)
# set defaults
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/SetDefaults.cmake)

add_subdirectory(src)

foreach(CONF_FILE Db.conf fossology.conf)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/install/defconf/${CONF_FILE}.in
        ${CMAKE_CURRENT_BINARY_DIR}/gen/${CONF_FILE}
        NEWLINE_STYLE UNIX
        @ONLY)
endforeach()

configure_file(${FO_CWD}/install/fo-postinstall.in
    ${CMAKE_CURRENT_BINARY_DIR}/gen/fo-postinstall
    NEWLINE_STYLE UNIX
    @ONLY)

configure_file(${FO_CWD}/install/db/dbcreate.in
    ${CMAKE_CURRENT_BINARY_DIR}/gen/dbcreate
    NEWLINE_STYLE UNIX
    @ONLY)

configure_file(${FO_CWD}/install/fossdash/fossdash-publish.py.in
    ${CMAKE_CURRENT_BINARY_DIR}/gen/fossdash-publish.py
    NEWLINE_STYLE UNIX
    @ONLY) 

configure_file(${FO_CWD}/install/db/db.cron.in
${CMAKE_CURRENT_BINARY_DIR}/gen/db.cron
NEWLINE_STYLE UNIX
    @ONLY)
add_custom_target(BUILD_version ALL 
        COMMAND ${CMAKE_COMMAND} 
            -DIN_FILE_NAME="VERSION.in"
            -DINPUT_FILE_DIR="${FO_CMAKEDIR}"
            -DOUTPUT_FILE_DIR="${PROJECT_BINARY_DIR}"
            -DOUT_FILE_NAME="VERSION"
            -DPROJECT_NAME="BUILD"
            -DFO_VERSION="${FO_VERSION}"
            -DFO_BRANCH="${FO_BRANCH}"
            -DFO_COMMIT_HASH="${FO_COMMIT_HASH}" 
            -DFO_BUILD_DATE="${FO_BUILD_DATE}" 
            -DFO_COMMIT_DATE="${FO_COMMIT_DATE}"
            -P ${FO_CMAKEDIR}/FoVersionFile.cmake
        DEPENDS "${FO_CMAKEDIR}/VERSION.in"
        COMMENT "Generating VERSION for ${FO_PROJECT}"
        BYPRODUCTS "${PROJECT_BINARY_DIR}/VERSION")

install(DIRECTORY  
    ${CMAKE_CURRENT_SOURCE_DIR}/install/defconf/
    ${CMAKE_CURRENT_SOURCE_DIR}/install/fossdash/
    DESTINATION ${FO_SYSCONFDIR}
    FILES_MATCHING
    PATTERN *.txt
    PATTERN *.yml)

install(DIRECTORY ${FO_CWD}/install/db/
    DESTINATION ${FO_LIBEXECDIR}
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.sql
    PATTERN *.json
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/gen/fo-postinstall
    ${CMAKE_CURRENT_BINARY_DIR}/gen/dbcreate
    ${FO_CWD}/install/fo_dbcheck.php
    ${FO_CWD}/install/fossinit-common.php
    ${FO_CWD}/install/fossinit.php
    ${CMAKE_CURRENT_BINARY_DIR}/gen/fossdash-publish.py
    DESTINATION ${FO_LIBEXECDIR}
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
        GROUP_READ GROUP_EXECUTE
        WORLD_READ WORLD_EXECUTE)
install(FILES ${FO_CWD}/install/fo-apache.conf 
    ${FO_CWD}/install/src-install-apache-example.conf
    DESTINATION ${FO_SYSCONFDIR}/conf)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/gen/db.cron
    DESTINATION /etc/cron.d/fossology)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/VERSION" ${CMAKE_CURRENT_BINARY_DIR}/gen/Db.conf 
${CMAKE_CURRENT_BINARY_DIR}/gen/fossology.conf
    DESTINATION ${FO_SYSCONFDIR})
