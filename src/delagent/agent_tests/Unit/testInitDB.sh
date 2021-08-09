#!/bin/sh
#/*********************************************************************
#Copyright (C) 2011 Hewlett-Packard Development Company, L.P.
#
#This program is free software; you can redistribute it and/or
#modify it under the terms of the GNU General Public License
#version 2 as published by the Free Software Foundation.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License along
#with this program; if not, write to the Free Software Foundation, Inc.,
#51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#*********************************************************************/

DBName=$1

FOSSYGID=$(id -Gn)
FOSSYUID=$(echo $FOSSYGID |grep -c 'fossy')
if [ $FOSSYUID -ne 1 ];then
  echo "Must be fossy group to run this script."
  exit 1
fi

#echo $UID
#echo $DBName

touch $HOME/connectdb.exp
{
  echo '#!/usr/bin/expect'
  echo 'set timeout 30'
  echo 'spawn psql -Ufossy -d '$DBName' < ../testdata/testdb_all.sql >/dev/null'
  echo 'expect "Password:"'
  echo 'send "fossy\r"'
  echo 'interact'
} >> $HOME/connectdb.exp


if expect $HOME/connectdb.exp;
then
  echo "Create Test database data Error!"
  exit 1
fi
#rm -f $HOME/connectdb.exp

echo "Create Test database data success!"
