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

set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -fopenmp")
find_package(Boost REQUIRED regex system filesystem program_options)
include_directories(
    ${glib_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
    ${jsoncpp_INCLUDE_DIRS}
    ${FO_CXXLIB_SRC}
)

add_compile_definitions( 
    _FILE_OFFSET_BITS=64 
    DATADIR="${FO_MODDIR}"
    VERSION_S="${FO_VERSION}"
    COMMIT_HASH_S="${FO_COMMIT_HASH}")

if(NOT TARGET fossologyCPP)
    add_subdirectory(${FO_CXXLIB_SRC} buildcxx EXCLUDE_FROM_ALL)
endif()

add_library(ojo EXCLUDE_FROM_ALL "")
add_library(ojo_cov EXCLUDE_FROM_ALL "")
add_executable(ojo_exec "")
add_executable(ojo_cov_exec EXCLUDE_FROM_ALL "")
foreach(FO_OJO_TARGET ojo ojo_exec ojo_cov ojo_cov_exec)
    target_sources(${FO_OJO_TARGET}
        PRIVATE
        ${FO_CWD}/OjosDatabaseHandler.cc
        ${FO_CWD}/ojoregex.cc
        ${FO_CWD}/ojos.cc
        ${FO_CWD}/OjoAgent.cc
        ${FO_CWD}/OjoState.cc
        ${FO_CWD}/directoryScan.cc
        ${FO_CWD}/OjoUtils.cc
    )
    if(${FO_OJO_TARGET} MATCHES "^ojo_cov")
        target_compile_options(${FO_OJO_TARGET}
            PRIVATE ${FO_COV_FLAGS})
    endif()
    if(${FO_OJO_TARGET} MATCHES "_exec$")
        target_link_libraries(${FO_OJO_TARGET} 
            PRIVATE fossologyCPP icuuc ${Boost_LIBRARIES} ${jsoncpp_LIBRARIES})
        string(REPLACE "_exec" "" FO_OJO_TARGET_R ${FO_OJO_TARGET})
        set_target_properties(${FO_OJO_TARGET}
            PROPERTIES OUTPUT_NAME ${FO_OJO_TARGET_R})
    endif()
endforeach()

install(TARGETS ojo_exec
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT ojo-agent)

# FIXME: coverage build is failing
