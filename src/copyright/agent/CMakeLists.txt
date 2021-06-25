set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${FO_CXX_FLAGS} -fopenmp -Wextra")

find_package(Boost REQUIRED regex system filesystem program_options)
include(FindPkgConfig)
include(FindPostgreSQL)
pkg_check_modules(GLIB REQUIRED glib-2.0)
pkg_check_modules(JSONCPP REQUIRED jsoncpp)

include_directories(
    ${GLIB_INCLUDE_DIRS}
    ${JSONCPP_INCLUDE_DIRS}
    ${PostgreSQL_INCLUDE_DIRS}
    ${FO_CLIB_SRC}
)
if(NOT TARGET fossologyCPP)
    add_subdirectory(${FO_CXXLIB_SRC} buildcpp EXCLUDE_FROM_ALL)
endif()

add_library(copyright "")
add_library(copyright_cov "")
add_executable(copyright_exec "")
add_executable(ecc "")
add_executable(keyword "")
add_executable(fo_unicode_clean "")
foreach(FO_COPY_TARGET copyright copyright_exec copyright_cov 
    ecc keyword fo_unicode_clean)
    if(${FO_COPY_TARGET} STREQUAL "^copyright")
        target_compile_definitions(${FO_COPY_TARGET}
            PRIVATE    
                DATADIR="${FO_MODDIR}"
                IDENTITY_COPYRIGHT
                _FILE_OFFSET_BITS=64
        )
    elseif(${FO_COPY_TARGET} STREQUAL "ecc")
        target_compile_definitions(${FO_COPY_TARGET}
            PRIVATE    
                DATADIR="${FO_MODDIR}"
                IDENTITY_ECC
                _FILE_OFFSET_BITS=64
        )
    elseif(${FO_COPY_TARGET} STREQUAL "keyword")
        target_compile_definitions(${FO_COPY_TARGET}
            PRIVATE    
                DATADIR="${FO_MODDIR}"
                IDENTITY_KW
                _FILE_OFFSET_BITS=64
        )
    endif()
    if(NOT ${FO_COPY_TARGET} STREQUAL "fo_unicode_clean")
        if(${FO_COPY_TARGET} MATCHES "^copyright")
            set(COP_XSRC copyscan.cc)
            set(COP_XINC copyscan.hpp)
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
            PUBLIC
            ${FO_CWD}/copyright.hpp
            ${FO_CWD}/regscan.hpp
            ${FO_CWD}/scanners.hpp
            ${FO_CWD}/cleanEntries.hpp
            ${FO_CWD}/regexConfProvider.hpp
            ${FO_CWD}/regexConfParser.hpp
            ${FO_CWD}/directoryScan.hpp
            ${FO_CWD}/copyrightUtils.hpp
            ${FO_CWD}/copyrightState.hpp
            ${FO_CWD}/database.hpp
            ${FO_CWD}/${COP_XINC}
        )
    else()
        target_sources(${FO_COPY_TARGET}
            PRIVATE
            ${FO_CWD}/FossologyUnicodeClean.cc
            ${FO_CWD}/FossologyUnicodeClean.hpp
        )
    endif()

    target_link_libraries(${FO_COPY_TARGET} 
        PRIVATE 
            fossologyCPP m icuuc icudata stdc++ 
            ${Boost_LIBRARIES} ${JSONCPP_LIBRARIES}
    )
endforeach()
target_compile_options(copyright_cov PRIVATE ${FO_COV_FLAGS})
set_target_properties(copyright_exec PROPERTIES OUTPUT_NAME copyright)

install(TARGETS copyright_exec fo_unicode_clean
    RUNTIME
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent 
    COMPONENT copyright)

foreach(COP ecc keyword)
    install(TARGETS ${COP}
        RUNTIME
        DESTINATION ${FO_MODDIR}/${COP}/agent
        COMPONENT ${COP})
endforeach()


# TODO: add version and commit info
# ASK: executable configurations
# BUG: coverage may not work on ninja