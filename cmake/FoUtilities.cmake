#[[--------------------------------------------------------------------
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
---------------------------------------------------------------------]]

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


#[[ add symbolic links for agents
    @param project name
    @param destination directory name
    @param link name
]]
macro(add_symlink)
    set(FO_ARGS ${ARGV})
    set(FO_LINK_SOURCE ${FO_MODDIR}/${PROJECT_NAME})
    set(FO_LINK_NAME "")
    set(MSG_NAME ${PROJECT_NAME})
    set(FO_LINK_DIR ${FO_SYSCONFDIR}/mods-enabled)
    if(${ARGC} EQUAL 1)
        list(GET FO_ARGS 0 FO_LINK_SOURCE)
    elseif(${ARGC} EQUAL 2)
        list(GET FO_ARGS 0 FO_LINK_SOURCE)
        list(GET FO_ARGS 1 FO_LINK_NAME)
        set(MSG_NAME ${FO_LINK_NAME})
    elseif(${ARGC} EQUAL 3)
        list(GET FO_ARGS 0 FO_LINK_SOURCE)
        list(GET FO_ARGS 1 FO_LINK_NAME)
        list(GET FO_ARGS 2 FO_LINK_DIR)
        set(MSG_NAME ${FO_LINK_NAME})
    endif()
    install(
        CODE "execute_process( \
            COMMAND mkdir -p \
            ${FO_LINK_DIR})"
        CODE "execute_process( \
            COMMAND ln -sf \ 
            ${FO_LINK_SOURCE} \
            ${FO_LINK_DIR}/${FO_LINK_NAME})"
        CODE "message(STATUS \"Added softlink for ${MSG_NAME}\")"
        COMPONENT ${PROJECT_NAME})
endmacro(add_symlink)

# ASK: correct bash scrips according to shellcheck??
