configure_file("${CMAKE_CURRENT_LIST_DIR}/version.php.in" 
    "${CMAKE_CURRENT_BINARY_DIR}/gen/version.php"
    NEWLINE_STYLE UNIX)

install(DIRECTORY ./ ${CMAKE_CURRENT_BINARY_DIR}/gen/
    DESTINATION ${FO_MODDIR}/${PROJECT_NAME}/agent
    COMPONENT unifiedreport
    FILES_MATCHING
    PATTERN *.php
)