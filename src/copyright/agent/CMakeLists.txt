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

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -fopenmp -Wextra")


include_directories(
    ${glib_INCLUDE_DIRS}
    ${jsoncpp_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
)
if(NOT TARGET fossologyCPP)
    add_subdirectory(${FO_CXXLIB_SRC} buildcpp EXCLUDE_FROM_ALL)
endif()
add_compile_definitions(
    DATADIR="${FO_MODDIR}"
    _FILE_OFFSET_BITS=64

    VERSION_S="${FO_VERSION}"
    COMMIT_HASH_S="${FO_COMMIT_HASH}")

add_library(copyright_lib EXCLUDE_FROM_ALL "")
add_library(copyright_cov_lib EXCLUDE_FROM_ALL "")
add_executable(copyright "")
add_executable(ecc "")
add_executable(keyword "")
add_executable(fo_unicode_clean "")
add_executable(copyright_cov EXCLUDE_FROM_ALL "")
foreach(FO_COPY_TARGET copyright_lib copyright copyright_cov_lib copyright_cov
    ecc keyword fo_unicode_clean)
    if(${FO_COPY_TARGET} MATCHES "^copyright")
        target_compile_definitions(${FO_COPY_TARGET}
            PRIVATE    
                IDENTITY_COPYRIGHT
        )
    elseif(${FO_COPY_TARGET} STREQUAL "ecc")
        target_compile_definitions(${FO_COPY_TARGET}
            PRIVATE    
                IDENTITY_ECC
        )
    elseif(${FO_COPY_TARGET} STREQUAL "keyword")
        target_compile_definitions(${FO_COPY_TARGET}
            PRIVATE    
                IDENTITY_KW
        )
    endif()
    if(NOT ${FO_COPY_TARGET} STREQUAL "fo_unicode_clean")
        if(${FO_COPY_TARGET} MATCHES "^copyright")
            set(COP_XSRC copyscan.cc)
        endif()
        target_sources(${FO_COPY_TARGET}
            PRIVATE
            ${FO_CWD}/copyright.cc
            ${FO_CWD}/regscan.cc
            ${FO_CWD}/scanners.cc
            ${FO_CWD}/cleanEntries.cc
            ${FO_CWD}/regexConfProvider.cc
            ${FO_CWD}/regexConfParser.cc
            ${FO_CWD}/directoryScan.cc
            ${FO_CWD}/copyrightUtils.cc
            ${FO_CWD}/copyrightState.cc
            ${FO_CWD}/database.cc
            ${FO_CWD}/${COP_XSRC}
        )
    else()
        target_sources(${FO_COPY_TARGET}
            PRIVATE
            ${FO_CWD}/FossologyUnicodeClean.cc
        )
    endif()

    target_link_libraries(${FO_COPY_TARGET} 
        PRIVATE 
            fossologyCPP m icuuc icudata stdc++ 
            ${Boost_LIBRARIES} ${jsoncpp_LIBRARIES}
    )
endforeach()
target_compile_options(copyright_cov PRIVATE ${FO_COV_FLAGS})
set_target_properties(copyright_lib PROPERTIES OUTPUT_NAME copyright)
set_target_properties(copyright_cov_lib PROPERTIES OUTPUT_NAME copyright_cov)

install(TARGETS fo_unicode_clean
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT copyright)

foreach(COP ecc keyword copyright)
    install(TARGETS ${COP}
        RUNTIME
        DESTINATION ${FO_MODDIR}/${COP}/agent
        COMPONENT ${COP})
    install(FILES ${COP}.conf
        DESTINATION ${FO_MODDIR}/${COP}/agent
        COMPONENT ${COP})
endforeach()


# BUG: coverage may not work 
