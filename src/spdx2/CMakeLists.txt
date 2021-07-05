cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(spdx2)
# set defaults

include(${CMAKE_CURRENT_SOURCE_DIR}/../../cmake/SetDefaults.cmake)


add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/agent)

generate_version()

install(DIRECTORY ui
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}
    COMPONENT spdx2
    FILES_MATCHING
    PATTERN *.php
    PATTERN "DepFiveAgentPlugin.php" EXCLUDE
    PATTERN "SpdxTwoTagValueAgentPlugin.php" EXCLUDE
)

install(FILES ui/DepFiveAgentPlugin.php
    DESTINATION ${FO_MODDIR}/dep5/ui
    COMPONENT spdx2)

install(FILES ui/SpdxTwoTagValueAgentPlugin.php
    DESTINATION ${FO_MODDIR}/spdx2tv/ui
    COMPONENT spdx2)

foreach(SPDX_INSTALL spdx2 spdx2tv dep5)
    install(FILES ${SPDX_INSTALL}.conf "${CMAKE_CURRENT_BINARY_DIR}/VERSION"
        DESTINATION ${FO_MODDIR}/${SPDX_INSTALL}
        COMPONENT spdx2)
    add_symlink(${FO_MODDIR}/${SPDX_INSTALL})
endforeach()