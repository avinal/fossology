generate_version_php()

install(DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/ ${CMAKE_CURRENT_BINARY_DIR}/gen/
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent
    COMPONENT deciderjob
    FILES_MATCHING
    PATTERN *.php
)