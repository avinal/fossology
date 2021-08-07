#[=======================================================================[
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
#]=======================================================================]

set(FO_PACKAGE_COMMON_DESCRIPTION 
"The FOSSology project is a web based framework that allows you to
upload software to be picked apart and then analyzed by software agents
which produce results that are then browsable via the web interface.
Existing agents include license analysis, metadata extraction, and MIME
type identification.
.")

## DEBIAN PACKAGING COMMON STUFF
set(CPACK_PACKAGE_VERSION ${FO_VERSION})
set(CPACK_GENERATOR DEB)
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "FOSSology - architecture for analyzing software")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Michael Jaeger <michael.c.jaeger@siemens.com>")
set(CPACK_DEBIAN_PACKAGE_HOMEPAGE "https://fossology.org")
set(CPACK_DEBIAN_PACKAGE_SOURCE "fossology")
set(CPACK_DEB_COMPONENT_INSTALL ON)
set(CPACK_RESOURCE_FILE_README "${FO_DEBDIR}/README.Debian")
set(CPACK_COMPONENTS_GROUPING "ONE_PER_GROUP")

## PACKING COMPONENTS
set(CPACK_COMPONENTS_ALL 
    adj2nest
    ununpack
    cli
    lib
    common
    maintagent
    vendor
    buckets
    copyright
    db
    debug
    decider
    deciderjob
    delagent
    mimetype
    monk
    monkbulk
    nomos
    ojo
    pkgagent
    readmeoss
    unifiedReport
    reuser
    reso
    scheduler
    softwareHeritage
    spasht
    spdx2
    reportImport
    wget_agent
    www)

## FOSSOLOGY-COMMON PACKAGE
set(CPACK_DEBIAN_FOSSOLOGY-COMMON_PACKAGE_NAME "fossology-common")
set(CPACK_DEBIAN_FOSSOLOGY-COMMON_FILE_NAME "fossology-common_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_FOSSOLOGY-COMMON_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the resources needed by all of the other
fossology components. This includes admin tools for maintenance.")

set(CPACK_DEBIAN_FOSSOLOGY-COMMON_PACKAGE_DEPENDS 
    "php7.0-pgsql | php7.2-pgsql | php7.3-pgsql | php7.4-pgsql, php-pear, 
    php7.0-cli | php7.2-cli | php7.3-cli | php7.4-cli, php-mbstring, 
    php7.0-json | php7.2-json | php7.3-json | php7.4-json, php-zip, php-xml, 
    php7.0-curl | php7.2-curl | php7.3-curl | php7.4-curl")

set(CPACK_DEBIAN_FOSSOLOGY-COMMON_PACKAGE_SECTION "utils")
set(CPACK_DEBIAN_FOSSOLOGY-COMMON_PACKAGE_CONTROL_EXTRA 
"${FO_DEBDIR}/common/postinst;${FO_DEBDIR}/common/postrm")

## FOSSOLOGY-WEB PACKAGE
set(CPACK_DEBIAN_WWW_PACKAGE_NAME "fossology-web")
set(CPACK_DEBIAN_WWW_FILE_NAME "fossology-web_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_WWW_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package depends on the packages for the web interface.")

set(CPACK_DEBIAN_WWW_PACKAGE_DEPENDS 
    "fossology-common, apache2, php7.0-gd|php7.2-gd|php7.3-gd|php7.4-gd,
    libapache2-mod-php7.0|libapache2-mod-php7.2|libapache2-mod-php7.3|libapache2-mod-php7.4")

set(CPACK_DEBIAN_WWW_PACKAGE_SECTION "utils")
set(CPACK_DEBIAN_WWW_PACKAGE_RECOMMENDS "fossology-db")
set(CPACK_DEBIAN_WWW_PACKAGE_CONTROL_EXTRA 
"${FO_DEBDIR}/web/postinst")

## FOSSOLOGY-SCHEDULER
set(CPACK_DEBIAN_SCHEDULER_PACKAGE_NAME "fossology-scheduler")
set(CPACK_DEBIAN_SCHEDULER_FILE_NAME "fossology-scheduler_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_SCHEDULER_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the scheduler daemon.")

set(CPACK_DEBIAN_SCHEDULER_PACKAGE_DEPENDS "fossology-common, s-nail")

set(CPACK_DEBIAN_SCHEDULER_PACKAGE_SECTION "utils")
set(CPACK_DEBIAN_SCHEDULER_PACKAGE_CONFLICTS "fossology-scheduler-single")
set(CPACK_DEBIAN_SCHEDULER_PACKAGE_CONTROL_EXTRA 
"${FO_DEBDIR}/scheduler/postinst" "${FO_DEBDIR}/scheduler/postrm")

## FOSSOLOGY-DB
set(CPACK_DEBIAN_DB_PACKAGE_NAME "fossology-db")
set(CPACK_DEBIAN_DB_FILE_NAME "fossology-db_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_DB_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the database resources and will create a
fossology database on the system (and requires that postgresql is
running at install time). If you prefer to use a remote database,
or want to create the database yourself, do not install this package
and consult the README.Debian file included in the fossology-common
package.")

set(CPACK_DEBIAN_DB_PACKAGE_DEPENDS "postgresql")

set(CPACK_DEBIAN_DB_PACKAGE_SECTION "utils")
set(CPACK_DEBIAN_DB_PACKAGE_CONTROL_EXTRA 
"${FO_DEBDIR}/db/postinst" "${FO_DEBDIR}/db/postrm")

if(NOT MONOPACK)
## FOSSOLOGY-UNUNPACK
set(CPACK_DEBIAN_FOSSOLOGY-UNUNPACK_PACKAGE_NAME "fossology-ununpack")
set(CPACK_DEBIAN_FOSSOLOGY-UNUNPACK_FILE_NAME "fossology-ununpack_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_FOSSOLOGY-UNUNPACK_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the ununpack and adj2nest agent programs and their
resources.")

set(CPACK_DEBIAN_FOSSOLOGY-UNUNPACK_PACKAGE_DEPENDS 
    "fossology-common, binutils, bzip2, cabextract, cpio, sleuthkit,
    genisoimage, poppler-utils, rpm, upx-ucl, unrar-free, unzip, p7zip-full,
    p7zip")

set(CPACK_DEBIAN_FOSSOLOGY-UNUNPACK_PACKAGE_SECTION "utils")
else()

## FOSSOLOGY-UNUNPACK
set(CPACK_DEBIAN_UNUNPACK_PACKAGE_NAME "fossology-ununpack")
set(CPACK_DEBIAN_UNUNPACK_FILE_NAME "fossology-ununpack_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_UNUNPACK_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the ununpack and adj2nest agent programs and their
resources.")

set(CPACK_DEBIAN_UNUNPACK_PACKAGE_DEPENDS 
    "fossology-common, binutils, bzip2, cabextract, cpio, sleuthkit,
    genisoimage, poppler-utils, rpm, upx-ucl, unrar-free, unzip, p7zip-full,
    p7zip")

set(CPACK_DEBIAN_UNUNPACK_PACKAGE_SECTION "utils")


## FOSSOLOGY-ADJ2NEST
set(CPACK_DEBIAN_ADJ2NEST_PACKAGE_NAME "fossology-adj2nest")
set(CPACK_DEBIAN_ADJ2NEST_FILE_NAME "fossology-adj2nest_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_ADJ2NEST_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the adj2nest and adj2nest agent programs and their
resources.")

set(CPACK_DEBIAN_ADJ2NEST_PACKAGE_DEPENDS 
    "fossology-common, binutils, bzip2, cabextract, cpio, sleuthkit,
    genisoimage, poppler-utils, rpm, upx-ucl, unrar-free, unzip, p7zip-full,
    p7zip")

set(CPACK_DEBIAN_ADJ2NEST_PACKAGE_SECTION "utils")
endif()

## FOSSOLOGY-COPYRIGHT
set(CPACK_DEBIAN_COPYRIGHT_PACKAGE_NAME "fossology-copyright")
set(CPACK_DEBIAN_COPYRIGHT_FILE_NAME "fossology-copyright_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_COPYRIGHT_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the copyright agent programs and their resources.")

set(CPACK_DEBIAN_COPYRIGHT_PACKAGE_DEPENDS 
    "fossology-common, libpcre3")

set(CPACK_DEBIAN_COPYRIGHT_PACKAGE_SECTION "utils")

## FOSSOLOGY-BUCKETS
set(CPACK_DEBIAN_BUCKETS_PACKAGE_NAME "fossology-buckets")
set(CPACK_DEBIAN_BUCKETS_FILE_NAME "fossology-buckets_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_BUCKETS_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the buckets agent programs and their resources.")

set(CPACK_DEBIAN_BUCKETS_PACKAGE_DEPENDS 
    "fossology-nomos, fossology-pkgagent")

set(CPACK_DEBIAN_BUCKETS_PACKAGE_SECTION "utils")

## FOSSOLOGY-MIMETYPE
set(CPACK_DEBIAN_MIMETYPE_PACKAGE_NAME "fossology-mimetype")
set(CPACK_DEBIAN_MIMETYPE_FILE_NAME "fossology-mimetype_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_MIMETYPE_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the mimetype agent programs and their resources.")

set(CPACK_DEBIAN_MIMETYPE_PACKAGE_DEPENDS 
    "fossology-common, libmagic1")

set(CPACK_DEBIAN_MIMETYPE_PACKAGE_SECTION "utils")

## FOSSOLOGY-NOMOS
set(CPACK_DEBIAN_NOMOS_PACKAGE_NAME "fossology-nomos")
set(CPACK_DEBIAN_NOMOS_FILE_NAME "fossology-nomos_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_NOMOS_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the nomos agent programs and their resources.")

set(CPACK_DEBIAN_NOMOS_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_NOMOS_PACKAGE_SECTION "utils")

## FOSSOLOGY-PKGAGENT
set(CPACK_DEBIAN_PKGAGENT_PACKAGE_NAME "fossology-pkgagent")
set(CPACK_DEBIAN_PKGAGENT_FILE_NAME "fossology-pkgagent_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_PKGAGENT_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the pgagent agent programs and their resources.")

set(CPACK_DEBIAN_PKGAGENT_PACKAGE_DEPENDS 
    "fossology-common, rpm")

set(CPACK_DEBIAN_PKGAGENT_PACKAGE_SECTION "utils")

## FOSSOLOGY-DELAGENT PACKAGE
set(CPACK_DEBIAN_DELAGENT_PACKAGE_NAME "fossology-delagent")
set(CPACK_DEBIAN_DELAGENT_FILE_NAME "fossology-delagent_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_DELAGENT_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the delagent agent programs and their resources.")

set(CPACK_DEBIAN_DELAGENT_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_DELAGENT_PACKAGE_SECTION "utils")

## FOSSOLOGY-WGETAGENT PACKAGE
set(CPACK_DEBIAN_WGET_AGENT_PACKAGE_NAME "fossology-wgetagent")
set(CPACK_DEBIAN_WGET_AGENT_FILE_NAME "fossology-wgetagent_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_WGET_AGENT_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the wgetagent programs and their resources.")

set(CPACK_DEBIAN_WGET_AGENT_PACKAGE_DEPENDS 
    "fossology-common, wget, subversion, git")

set(CPACK_DEBIAN_WGET_AGENT_PACKAGE_SECTION "utils")

## FOSSOLOGY-DEBUG PACKAGE
set(CPACK_DEBIAN_DEBUG_PACKAGE_NAME "fossology-debug")
set(CPACK_DEBIAN_DEBUG_FILE_NAME "fossology-debug_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_DEBUG_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the debug UI.")

set(CPACK_DEBIAN_DEBUG_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_DEBUG_PACKAGE_SECTION "utils")

## FOSSOLOGY-MONK PACKAGE
set(CPACK_DEBIAN_MONK_PACKAGE_NAME "fossology-monk")
set(CPACK_DEBIAN_MONK_FILE_NAME "fossology-monk_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_MONK_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the monk agent programs and their resources.")

set(CPACK_DEBIAN_MONK_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_MONK_PACKAGE_SECTION "utils")

## FOSSOLOGY-MONKBULK PACKAGE
set(CPACK_DEBIAN_MONKBULK_PACKAGE_NAME "fossology-monkbulk")
set(CPACK_DEBIAN_MONKBULK_FILE_NAME "fossology-monkbulk_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_MONKBULK_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the monkbulk agent programs and their resources.")

set(CPACK_DEBIAN_MONKBULK_PACKAGE_DEPENDS 
    "fossology-common, fossology-deciderjob")

set(CPACK_DEBIAN_MONKBULK_PACKAGE_SECTION "utils")

## FOSSOLOGY-OJO PACKAGE
set(CPACK_DEBIAN_OJO_PACKAGE_NAME "fossology-ojo")
set(CPACK_DEBIAN_OJO_FILE_NAME "fossology-ojo_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_OJO_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the ojo agent programs and their resources.")

set(CPACK_DEBIAN_OJO_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_OJO_PACKAGE_SECTION "utils")


## FOSSOLOGY-DECIDER PACKAGE
set(CPACK_DEBIAN_DECIDER_PACKAGE_NAME "fossology-decider")
set(CPACK_DEBIAN_DECIDER_FILE_NAME "fossology-decider_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_DECIDER_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the decider agent programs and their resources.")

set(CPACK_DEBIAN_DECIDER_PACKAGE_DEPENDS 
    "fossology-common, fossology-deciderjob")

set(CPACK_DEBIAN_DECIDER_PACKAGE_SECTION "utils")

## FOSSOLOGY-DECIDERJOB PACKAGE
set(CPACK_DEBIAN_DECIDERJOB_PACKAGE_NAME "fossology-deciderjob")
set(CPACK_DEBIAN_DECIDERJOB_FILE_NAME "fossology-deciderjob_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_DECIDERJOB_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the deciderjob agent programs and their resources.")

set(CPACK_DEBIAN_DECIDERJOB_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_DECIDERJOB_PACKAGE_SECTION "utils")

## FOSSOLOGY-READMEOSS PACKAGE
set(CPACK_DEBIAN_READMEOSS_PACKAGE_NAME "fossology-readmeoss")
set(CPACK_DEBIAN_READMEOSS_FILE_NAME "fossology-readmeoss_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_READMEOSS_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the readmeoss agent programs and their resources.")

set(CPACK_DEBIAN_READMEOSS_PACKAGE_DEPENDS 
    "fossology-common, fossology-copyright")

set(CPACK_DEBIAN_READMEOSS_PACKAGE_SECTION "utils")

## FOSSOLOGY-RESO PACKAGE
set(CPACK_DEBIAN_RESO_PACKAGE_NAME "fossology-reso")
set(CPACK_DEBIAN_RESO_FILE_NAME "fossology-reso_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_RESO_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the reso agent programs and their resources.")

set(CPACK_DEBIAN_RESO_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_RESO_PACKAGE_SECTION "utils")

## FOSSOLOGY-UNIFIEDREPORT PACKAGE
set(CPACK_DEBIAN_UNIFIEDREPORT_PACKAGE_NAME "fossology-unifiedreport")
set(CPACK_DEBIAN_UNIFIEDREPORT_FILE_NAME "fossology-unifiedreport_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_UNIFIEDREPORT_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the unifiedreport agent programs and their resources.")

set(CPACK_DEBIAN_UNIFIEDREPORT_PACKAGE_DEPENDS 
    "fossology-common, php-zip, php-xml")

set(CPACK_DEBIAN_UNIFIEDREPORT_PACKAGE_SECTION "utils")

## FOSSOLOGY-REUSER PACKAGE
set(CPACK_DEBIAN_REUSER_PACKAGE_NAME "fossology-reuser")
set(CPACK_DEBIAN_REUSER_FILE_NAME "fossology-reuser_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_REUSER_DESCRIPTION 
"architecture for reusing clearing result of other uploads, reuser
${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the reuser agent programs and their resources.")

set(CPACK_DEBIAN_REUSER_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_REUSER_PACKAGE_SECTION "utils")

## FOSSOLOGY-SPDX2 PACKAGE
set(CPACK_DEBIAN_SPDX2_PACKAGE_NAME "fossology-spdx2")
set(CPACK_DEBIAN_SPDX2_FILE_NAME "fossology-spdx2_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_SPDX2_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the spdx2 agent programs and their resources.")

set(CPACK_DEBIAN_SPDX2_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_SPDX2_PACKAGE_SECTION "utils")

## FOSSOLOGY-REPORTIMPORT PACKAGE
set(CPACK_DEBIAN_REPORTIMPORT_PACKAGE_NAME "fossology-reportimport")
set(CPACK_DEBIAN_REPORTIMPORT_FILE_NAME "fossology-reportimport_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_REPORTIMPORT_DESCRIPTION 
"${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the reportimport agent programs and their resources.")

set(CPACK_DEBIAN_REPORTIMPORT_PACKAGE_DEPENDS 
    "fossology-common, php-mbstring")

set(CPACK_DEBIAN_REPORTIMPORT_PACKAGE_SECTION "utils")

## FOSSOLOGY-SOFTWAREHERITAGE PACKAGE
set(CPACK_DEBIAN_SOFTWAREHERITAGE_PACKAGE_NAME "fossology-softwareheritage")
set(CPACK_DEBIAN_SOFTWAREHERITAGE_FILE_NAME "fossology-softwareheritage_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_SOFTWAREHERITAGE_DESCRIPTION 
"architecture for fetching the origin of a file software heritage archive.
${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the softwareheritage agent programs and their resources.")

set(CPACK_DEBIAN_SOFTWAREHERITAGE_PACKAGE_DEPENDS 
    "fossology-common, fossology-ununpack, fossology-wgetagent")

set(CPACK_DEBIAN_SOFTWAREHERITAGE_PACKAGE_SECTION "utils")

## FOSSOLOGY-SPASHT PACKAGE
set(CPACK_DEBIAN_SPASHT_PACKAGE_NAME "fossology-spasht")
set(CPACK_DEBIAN_SPASHT_FILE_NAME "fossology-spasht_${FO_VERSION}_amd64.deb")
set(CPACK_DEBIAN_SPASHT_DESCRIPTION 
"architecture to connect clearlyDefined, spasht
${FO_PACKAGE_COMMON_DESCRIPTION}
This package contains the spasht agent programs and their resources.")

set(CPACK_DEBIAN_SPASHT_PACKAGE_DEPENDS 
    "fossology-common")

set(CPACK_DEBIAN_SPASHT_PACKAGE_SECTION "utils")


## include CPACK
include(CPack)

## specify groups

## fossology-common package group
cpack_add_component_group(fossology-common)
cpack_add_component(cli REQUIRED GROUP fossology-common)
cpack_add_component(common REQUIRED GROUP fossology-common)
cpack_add_component(maintagent REQUIRED GROUP fossology-common)
cpack_add_component(lib REQUIRED GROUP fossology-common)
cpack_add_component(vendor REQUIRED GROUP fossology-common)

if(NOT MONOPACK)
## fossology-ununpack package group
cpack_add_component_group(fossology-ununpack)
cpack_add_component(ununpack REQUIRED GROUP fossology-ununpack)
cpack_add_component(adj2nest REQUIRED GROUP fossology-ununpack)
endif()
