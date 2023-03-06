#!/bin/bash
# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Global Config
DB_HOST=${1}
DB_USER=${2}
DB_PASSWORD=${3}
NFS_IP_ADDRESS=${4}
VERSION="14.10.4"
XWIKI_FLAVOR_DATA_DIR="/home"
MYSQL_IMPORT_SQL_FILE="xwiki_bk_14.10.sql"
NFS_SHARE_FILE="file_${VERSION}.tar.gz"
XWIKI_DATA_DIR="/var/lib/xwiki/data"
FLAVOR_LOG_PREFIX="Deploy_flavor:"
LOCK_FILE="${XWIKI_DATA_DIR}/store/file/import.lock"
IMPORTED="${XWIKI_DATA_DIR}/store/file/imported"

Migrate_Data() {
  (
    flock -x -n 200 || exit 1
    if [ -f ${IMPORTED} ]; then
      echo "${FLAVOR_LOG_PREFIX} Data migration has completed. Function returned."
    else
      CONNECTION_RETRIES=20
      retries=0
      while ! mysql -u${DB_USER} --password="${DB_PASSWORD}" -h${DB_HOST} xwiki -e "exit" --connect-timeout=20
      do
        retries=$((retries+1))
        if [ "$retries" -lt $CONNECTION_RETRIES ]; then
          echo "MySQL server is not ready for login. Retrying in 3 sec..."
          sleep 3
        else
          echo "ERROR: Couldn't login MySQL server ${DB_HOST}!"
        fi
      done

      TABLE_COUNT=$(mysql -u${DB_USER} --password="${DB_PASSWORD}" -h${DB_HOST} xwiki -e "show tables;" | wc -l)
      if [ ${TABLE_COUNT} -gt 0 ] ; then
        echo "Xwiki Flavor ${VERSION} table data has already exists. Skipping table data import!"
      else
        echo "Xwiki Flavor ${VERSION} table data does not exist! Importing table data..."
        sudo tar zxvf ${XWIKI_FLAVOR_DATA_DIR}/xwiki_mysql_db_bk_14.10.4.tar.gz -C ${XWIKI_FLAVOR_DATA_DIR}/
        mysql -u${DB_USER} --password="${DB_PASSWORD}" -h${DB_HOST} xwiki < ${XWIKI_FLAVOR_DATA_DIR}/${MYSQL_IMPORT_SQL_FILE}
        if [ $? -eq 0 ]; then
          echo "Importing table data has been completed!"
        else
          echo "ERROR: Failed to import table data."
        fi
      fi

      if sudo test -d ${XWIKI_DATA_DIR}/store/file/xwiki ; then
        echo "The Xwiki Flavor ${VERSION} share file has already been mounted on NFS folder. Skipping file extraction!"
      else
        echo "The Xwiki Flavor ${VERSION} share file does not exist on NFS folder. Extracting file..."
        sudo tar -zxvf ${XWIKI_FLAVOR_DATA_DIR}/file_${VERSION}.tar.gz -C ${XWIKI_DATA_DIR}/store
        if [ $? -eq 0 ]; then
          echo "XWiki Flavor share file extraction to NFS folder completed!"
        else
          echo "ERROR: Failed to extract XWiki Flavor data to NFS folder."
        fi
      fi
      echo "${FLAVOR_LOG_PREFIX} Data migration has completed."
      date > ${IMPORTED}
    fi
  ) 200>$LOCK_FILE
}

CONNECTION_RETRIES=20
retries=0
while ! (mount | grep "xwiki_file_share")
do
  retries=$((retries+1))
  if [ "$retries" -lt $CONNECTION_RETRIES ]; then
    echo "Connection to NFS share folder not found. Retrying in 3 sec..."
    sleep 3
  else
    echo "ERROR: Couldn't connect to NFS share folder!"
    exit 1
  fi
done

Migrate_Data
if [ $? -eq 1 ]; then
  echo "${FLAVOR_LOG_PREFIX} Data migration is in progress."
  RETRY_INTERVAL=120
  retries=0
  while true; do
    retries=$((retries+1))
    if [ -f ${IMPORTED} ]; then
      echo "${FLAVOR_LOG_PREFIX} Data migration has completed."
      break
    else
      echo "${FLAVOR_LOG_PREFIX} Still waiting for data migration..."
    fi
    if [ "$retries" -ge $RETRY_INTERVAL ]; then
      echo "${FLAVOR_LOG_PREFIX} Data migration timed out."
      break
    fi
    sleep 1
  done
fi

echo "-----Starting tomcat9-----"
sudo systemctl restart tomcat9
sudo systemctl enable tomcat9
echo "-----XWiki has been successfully deployed-----"