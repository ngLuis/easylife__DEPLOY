#!/usr/bin/env bash

TYPE=$1

echo $TYPE

echo "$TYPE"

if [ "$TYPE" = "produccion" ]; then
   sudo sh ./deployMysql.sh
   sudo sh ./deployApi.sh produccion
   sudo sh ./deploySite.sh produccion
elif [ "$TYPE" = "preproduccion" ]; then
   sudo sh ./deployMysql.sh
   sudo sh ./deployApi.sh preproduccion
   sudo sh ./deploySite.sh preproduccion
fi