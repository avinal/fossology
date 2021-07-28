#[=======================================================================[
SPDX-License-Identifier: GPL-2.0
SPDX-FileCopyrightText: 2021 Avinal Kumar <avinal.xlvii@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
version 2 as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#]=======================================================================]

#[[ macro to get latest version
    @param git version
    commit hash
    build time
    commit time
]]
macro(getGitVersion)
    find_package(Git REQUIRED)
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" describe --tags
        COMMAND head -1
        WORKING_DIRECTORY "${FO_SOURCEDIR}"
        OUTPUT_VARIABLE VERSION_GIT
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REPLACE "-" ";" FO_VERSION_GIT "${VERSION_GIT}")
    list(LENGTH FO_VERSION_GIT VAR_LEN)
    if(${VAR_LEN} EQUAL 2) 
        list(GET FO_VERSION_GIT 0 VERSION_GIT)
        string(APPEND ".0" ${VERSION_GIT})
    elseif(${VAR_LEN} EQUAL 3)
        string(REGEX REPLACE 
        "^([0-9]+\\.[0-9]+\\.[0-9]+)-([0-9]*)-g[0-9a-z]*"
        "\\1.\\2" VERSION_GIT ${VERSION_GIT})
    elseif(${VAR_LEN} EQUAL 4)
        string(REGEX REPLACE 
        "^([0-9]+\\.[0-9]+\\.[0-9]+)(-rc[0-9]+)-([0-9]*)-g[0-9a-z]*"
        "\\1.\\3\\2" VERSION_GIT ${VERSION_GIT})
    endif()
    set(FO_VERSION ${VERSION_GIT} CACHE INTERNAL "fossology version")
    message(STATUS "Current fossology version ${FO_VERSION}")

    execute_process(
        COMMAND "${GIT_EXECUTABLE}" show -s --format=%h
        COMMAND head -1
        WORKING_DIRECTORY "${FO_SOURCEDIR}"
        OUTPUT_VARIABLE COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    string(SUBSTRING "${COMMIT_HASH}" 0 6 COMMIT_HASH)
    set(FO_COMMIT_HASH ${COMMIT_HASH} CACHE INTERNAL "latest commit hash")
    message(STATUS "Latest commit hash: ${FO_COMMIT_HASH}")

    execute_process(
        COMMAND "${GIT_EXECUTABLE}" rev-parse --abbrev-ref HEAD
        COMMAND head -1
        WORKING_DIRECTORY "${FO_SOURCEDIR}"
        OUTPUT_VARIABLE BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(FO_BRANCH ${BRANCH} CACHE INTERNAL "current branch")
    message(STATUS "Current Branch: ${FO_BRANCH}")
    execute_process(
        COMMAND date +"%Y/%m/%d %R %Z"
        OUTPUT_VARIABLE BUILD_DATE
        OUTPUT_STRIP_TRAILING_WHITESPACE
        WORKING_DIRECTORY ${FO_SOURCEDIR}
    )
    set(FO_BUILD_DATE ${BUILD_DATE} CACHE INTERNAL "latest build date")
    message(STATUS "Current Build Data: ${FO_BUILD_DATE}")
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" show -s --format=@%ct
        COMMAND date +"%Y/%m/%d %R %Z" -f -
        OUTPUT_VARIABLE COMMIT_DATE
        OUTPUT_STRIP_TRAILING_WHITESPACE
        WORKING_DIRECTORY ${FO_SOURCEDIR}
    )
    set(FO_COMMIT_DATE ${COMMIT_DATE} CACHE INTERNAL "latest commit hash")
    message(STATUS "Latest Commit date: ${FO_COMMIT_DATE}")

    set_property(GLOBAL APPEND
        PROPERTY CMAKE_CONFIGURE_DEPENDS
        "${CMAKE_SOURCE_DIR}/.git/index")
endmacro(getGitVersion)


#[[ generate VERSION file for agents
    @param Project Name
    @param version file name
]]
macro(generate_version)
    set(FO_ARGS ${ARGV})
    if(${ARGC} EQUAL 0)
        set(FO_PROJECT_NAME ${PROJECT_NAME})
        set(VERSION_FILE_NAME "VERSION")
    elseif(${ARGC} EQUAL 1)
        list(GET FO_ARGS 0 FO_PROJECT_NAME)
        set(VERSION_FILE_NAME "VERSION")
    elseif(${ARGC} EQUAL 2)
        list(GET FO_ARGS 0 FO_PROJECT_NAME)
        list(GET FO_ARGS 1 VERSION_FILE_NAME)
    endif()
    add_custom_target(${FO_PROJECT_NAME}_version ALL 
        COMMAND ${CMAKE_COMMAND} 
            -DIN_FILE_NAME="VERSION.in"
            -DINPUT_FILE_DIR="${FO_CMAKEDIR}"
            -DOUTPUT_FILE_DIR="${PROJECT_BINARY_DIR}"
            -DOUT_FILE_NAME="${VERSION_FILE_NAME}"
            -DPROJECT_NAME="${PROJECT_NAME}"
            -DFO_VERSION="${FO_VERSION}"
            -DFO_BRANCH="${FO_BRANCH}"
            -DFO_COMMIT_HASH="${FO_COMMIT_HASH}" 
            -DFO_BUILD_DATE="${FO_BUILD_DATE}" 
            -DFO_COMMIT_DATE="${FO_COMMIT_DATE}"
            -P ${FO_CMAKEDIR}/FoVersionFile.cmake
        DEPENDS "${FO_CMAKEDIR}/VERSION.in" "${FO_PROJECT_NAME}"
        COMMENT "Generating ${VERSION_FILE_NAME} for ${FO_PROJECT_NAME}"
        BYPRODUCTS "${PROJECT_BINARY_DIR}/${VERSION_FILE_NAME}")
endmacro(generate_version)


#[[ generate version.php for php agents
    @param project name
]]
macro(generate_version_php)
    set(FO_ARGS ${ARGV})
    if(${ARGC} EQUAL 0)
        set(FO_PROJECT_NAME ${PROJECT_NAME})
    elseif(${ARGC} EQUAL 1)
        list(GET FO_ARGS 0 FO_PROJECT_NAME)
    endif()
    add_custom_target(${FO_PROJECT_NAME} ALL
        COMMAND ${CMAKE_COMMAND} 
            -DIN_FILE_NAME="version.php.in"
            -DINPUT_FILE_DIR="${CMAKE_CURRENT_SOURCE_DIR}"
            -DOUTPUT_FILE_DIR="${CMAKE_CURRENT_BINARY_DIR}/gen"
            -DOUT_FILE_NAME="version.php"
            -DFO_VERSION="${FO_VERSION}"
            -DFO_COMMIT_HASH="${FO_COMMIT_HASH}"
            -P ${FO_CMAKEDIR}/FoVersionFile.cmake
            BYPRODUCTS "${CMAKE_CURRENT_BINARY_DIR}/gen/version.php"
            COMMENT "Generating version.php for ${FO_PROJECT_NAME}"
            DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/version.php.in")
endmacro(generate_version_php)


macro(add_symlink)
    set(LINK_NAME ${PROJECT_NAME})
    set(LINK_TARGET ${FO_MODDIR}/${PROJECT_NAME})
    set(LINK_DESTINATION ${FO_SYSCONFDIR}/mods-enabled)
    set(FO_ARGS ${ARGV})
    if(${ARGC} EQUAL 1)
        list(GET FO_ARGS 0 LINK_NAME)
    elseif(${ARGC} EQUAL 2)
        list(GET FO_ARGS 0 LINK_NAME)
        list(GET FO_ARGS 1 LINK_TARGET)
    elseif(${ARGC} EQUAL 3)
        list(GET FO_ARGS 0 LINK_NAME)
        list(GET FO_ARGS 1 LINK_TARGET)
        list(GET FO_ARGS 2 LINK_DESTINATION)
    endif()
    get_filename_component(LINK_TARGET_NAME ${LINK_TARGET} NAME_WE)
    # add_custom_target(${LINK_NAME}_${LINK_TARGET_NAME}_symlink ALL
    #     COMMENT "Generating symbolic link: ${LINK_NAME} -> ${LINK_TARGET}"
    #     COMMAND ln -sf -T ${LINK_TARGET} ${CMAKE_CURRENT_BINARY_DIR}/${LINK_NAME}
    #     DEPENDS ${PROJECT_NAME}
    #     BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/${LINK_NAME})
    # install(
    #     CODE "message(\"adding link for ${LINK_DESTINATION}\")"
    #     CODE "execute_process(COMMAND mkdir -p ${LINK_DESTINATION})"
    #     CODE "file(INSTALL DESTINATION ${LINK_DESTINATION} TYPE FILE FILES ${CMAKE_CURRENT_BINARY_DIR}/${LINK_NAME})"
    #     CODE "message(STATUS \"Added symbolic link: ${LINK_NAME} -> ${LINK_TARGET}\")"
    #     COMPONENT ${PROJECT_NAME})
    # install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${LINK_NAME}
    #     DESTINATION ${LINK_DESTINATION}
    #     COMPONENT ${PROJECT_NAME})
    install(CODE "message(STATUS \"adding symlink for ${LINK_DESTINATION}\")"
        CODE "execute_process(COMMAND mkdir -p ${LINK_DESTINATION})"
        CODE "execute_process(COMMAND ln -sf -T ${LINK_TARGET} ${LINK_DESTINATION}/${LINK_NAME})"
        CODE "message(STATUS \"Added symbolic link: ${LINK_NAME} -> ${LINK_TARGET}\")"
        COMPONENT ${PROJECT_NAME})
endmacro(add_symlink)


function (basic_install_link OLD NEW)
   set (CMD_IN
     "
     set (OLD \"@OLD@\")
     set (NEW \"@NEW@\")
     message(\"${PROJECT_NAME} here1\")
     if (NOT IS_ABSOLUTE \"\${OLD}\")
       set (OLD \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/\${OLD}\")
     endif ()
     if (NOT IS_ABSOLUTE \"\${NEW}\")
       set (NEW \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/\${NEW}\")
     endif ()
 
     if (IS_SYMLINK \"\${NEW}\")
       file (REMOVE \"\${NEW}\")
     endif ()
     message(\"${PROJECT_NAME} here 2\")
     if (EXISTS \"\${NEW}\")
       message (STATUS \"Skipping: \${NEW} -> \${OLD}\")
     else ()
       message (STATUS \"Installing: \${NEW} -> \${OLD}\")
       message(\"${PROJECT_NAME} here 3\")
       get_filename_component (SYMDIR \"\${NEW}\" PATH)
 
       file (RELATIVE_PATH OLD \"\${SYMDIR}\" \"\${OLD}\")
 
       if (NOT EXISTS \${SYMDIR})
         file (MAKE_DIRECTORY \"\${SYMDIR}\")
       endif ()
       message(\"${PROJECT_NAME} here 4\")
       execute_process (
         COMMAND ln -sf -T \"\${OLD}\" \"\${NEW}\"
         RESULT_VARIABLE RETVAL
       )
       message(\"${PROJECT_NAME} here 5\")
       if (NOT RETVAL EQUAL 0)
         message (ERROR \"Failed to create (symbolic) link \${NEW} -> \${OLD}\")
       else ()
         list (APPEND CMAKE_ABSOLUTE_DESTINATION_FILES \"\${NEW}\")
       endif ()
     endif ()
     "
   )
 
   string (CONFIGURE "${CMD_IN}" CMD @ONLY)
   install (CODE "${CMD}" COMPONENT "${PROJECT_NAME}")
 endfunction ()