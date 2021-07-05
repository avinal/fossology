generate_version_php()

install(DIRECTORY ./ ${CMAKE_CURRENT_BINARY_DIR}/gen/ 
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent
    COMPONENT spdx2
    FILES_MATCHING
    PATTERN *.php
    PATTERN *.twig
)

foreach(SPDX_INSTALL spdx2 spdx2tv dep5)
    install(FILES agent.sh
        DESTINATION ${FO_MODDIR}/${SPDX_INSTALL}/agent
        RENAME ${SPDX_INSTALL}.sh
        COMPONENT spdx2)
endforeach()
