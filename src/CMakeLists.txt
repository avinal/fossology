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

add_subdirectory(lib)
add_subdirectory(scheduler)
add_subdirectory(adj2nest)
add_subdirectory(buckets)
add_subdirectory(copyright)
add_subdirectory(cli)
add_subdirectory(decider)
add_subdirectory(deciderjob)
add_subdirectory(delagent)
add_subdirectory(debug)
add_subdirectory(maintagent)
add_subdirectory(mimetype)
add_subdirectory(pkgagent)
add_subdirectory(ojo)
add_subdirectory(readmeoss)
add_subdirectory(reportImport)
add_subdirectory(reuser)
add_subdirectory(reso)
add_subdirectory(spasht)
add_subdirectory(spdx2)
add_subdirectory(softwareHeritage)
add_subdirectory(nomos)
add_subdirectory(monk)
add_subdirectory(ununpack)
add_subdirectory(unifiedreport)
add_subdirectory(wget_agent)
add_subdirectory(www)
if(NOT OFFLINE)
    add_subdirectory(genvendor)
endif()

# deprecated or not used agents
# add_subdirectory(demomod)
# add_subdirectory(example_wc_agent)
# add_subdirectory(ninka)
# add_subdirectory(regexscan)
