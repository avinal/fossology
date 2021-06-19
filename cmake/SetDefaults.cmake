
# set all the default variable in cache
set(FO_PROJECT "fossology" CACHE INTERNAL "The name of our project")

set(FO_PROJECTUSER "fossy" CACHE INTERNAL "user for the project in the system")

set(FO_PROJECTGROUP "fossy" CACHE INTERNAL "group for the project in the system")

# agents library and source paths
get_filename_component(FO_BASEDIR ${CMAKE_CURRENT_LIST_DIR}/../ ABSOLUTE CACHE PATH)

list(APPEND CMAKE_MODULE_PATH "${FO_BASEDIR}/cmake")

set(FO_SOURCEDIR "${FO_BASEDIR}/src" CACHE PATH "source directory of fossology")

set(FO_CLIB_SRC "${FO_SOURCEDIR}/lib/c" CACHE PATH "path to fossology c library source directory")

set(FO_CXXLIB_SRC "${FO_SOURCEDIR}/lib/cpp" CACHE PATH "path to fossology c++ library source directory")

set(FO_PHPLIB_SRC "${FO_SOURCEDIR}/lib/php" CACHE PATH "path to fossology php library source directory")

set(FO_CLI_SRC "${FO_SOURCEDIR}/cli" CACHE PATH "path to fossology cli source directory")

set(FO_SCH_SRC "${FO_SOURCEDIR}/scheduler" CACHE PATH "path to fossology scheduler source directory")


# common flags and options (always use list for flags)
set(FO_C_FLAGS "-Wall" CACHE INTERNAL "default fossology c flags")

set(FO_CXX_FLAGS "${FO_C_FLAGS} --std=c++0x" CACHE INTERNAL "default fossology c++ flags")

set(FO_COV_FLAGS "-O0;-fprofile-arcs;-ftest-coverage" CACHE INTERNAL "coverage flags for fossology")


# Install paths
set(FO_DESTDIR "" CACHE INTERNAL "pseudoroot for packaging purposes")

set(FO_PREFIX "/usr/local" CACHE PATH "base of the program data tree")

set(FO_BINDIR "${FO_PREFIX}/bin" CACHE PATH "executable programs that users run")

set(FO_SBINDIR "${FO_PREFIX}/sbin" CACHE PATH "executable programs that sysadmins can run")

set(FO_SYSCONFDIR "${FO_PREFIX}/etc/${FO_PROJECT}" CACHE PATH "configuration files")

set(FO_INITDIR "/etc" CACHE PATH "init script root dir")

set(FO_LIBDIR "${FO_PREFIX}/lib" CACHE PATH "object code libraries")

set(FO_INCLUDEDIR "${FO_PREFIX}/include" CACHE PATH "include files")

set(FO_LIBEXECDIR "${FO_PREFIX}/lib/${FO_PROJECT}" CACHE PATH "executables/libraries that only our project uses")

set(FO_DATAROOTDIR "${FO_PREFIX}/share" CACHE PATH "non-arch-specific data")

set(FO_MODDIR "${FO_DATAROOTDIR}/${FO_PROJECT}" CACHE PATH "non-arch-dependent program data")

set(FO_REPODIR "/srv/${FO_PROJECT}/repository" CACHE PATH "hardcoded repository location")

set(FO_LOCALSTATEDIR "/var/local" CACHE PATH "local state")

set(FO_PROJECTSTATEDIR "${FO_LOCALSTATEDIR}/lib/${FO_PROJECT}" CACHE PATH "project local state")

set(FO_CACHEDIR "${FO_LOCALSTATEDIR}/lib/${FO_PROJECT}" CACHE PATH "cache dir")

set(FO_LOGDIR "/var/log/${FO_PROJECT}" CACHE PATH "project logdir")

set(FO_MANDIR "${FO_DATAROOTDIR}/man" CACHE PATH "manpages")

set(FO_MAN1DIR "${FO_MANDIR}/man1" CACHE PATH "man pages in *roff format, man 1")

set(FO_DOCDIR "${DATAROOTDIR}/doc/${FO_PROJECT}" CACHE PATH "project documentation")

set(FO_WEBDIR "${FO_MODDIR}/www" CACHE PATH "webroot")

set(FO_PHPDIR "${FO_MODDIR}/php" CACHE PATH "php root")


set(ARE_DEFAULTS_SET ON CACHE BOOL "flag to check if defaults have been set")


message(STATUS "The defaults have been set")