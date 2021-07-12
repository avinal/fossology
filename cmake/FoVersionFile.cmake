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

#[[ template file for generating various files at build and install times
    @param input file's directory
    @param input file name
    @param output file's directory
    @param output file name
]]
configure_file(
    "${INPUT_FILE_DIR}/${IN_FILE_NAME}"
    "${OUTPUT_FILE_DIR}/${OUT_FILE_NAME}"
    NEWLINE_STYLE UNIX
    @ONLY)
