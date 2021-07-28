
set(FO_CWD ${CMAKE_CURRENT_SOURCE_DIR})

add_library(fodbreposysconf EXCLUDE_FROM_ALL ${FO_CWD}/libfodbreposysconf.c)
target_compile_definitions(fodbreposysconf PRIVATE 
    TESTDBDIR="${FO_TESTDIR}/db"
    _FILE_OFFSET_BITS=64)
target_include_directories(fodbreposysconf PRIVATE ${FO_CLIB_SRC} ${glib_INCLUDE_DIRS}
${PostgreSQL_INCLUDE_DIRS})
