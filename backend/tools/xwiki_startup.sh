#! /bin/bash

## Global Config
SQL_ENDPOINT=$1
SQL_USER_NAME=$2
SQL_USER_PASSWORD=$3
FILESTORE_IP_ADDRESS=$4

Config_Xwiki(){
    echo "-----Config jgroup setting to XWiki -----"
    sudo su -c "echo -e \"observation.remote.enabled = true \nobservation.remote.channels = tcp \" | tee -a /etc/xwiki/xwiki.properties"

    echo "-----Config Mysql connection setting to Xwiki -----"
    sudo su -c "sed -i \"s/jdbc:mysql:\/\/xwiki-sql-db/jdbc:mysql:\/\/${SQL_ENDPOINT}/g\" /etc/xwiki/hibernate.cfg.xml"
    sudo su -c "sed -i \"s/xwiki-sql-db-username/${SQL_USER_NAME}/g\" /etc/xwiki/hibernate.cfg.xml"
    sudo su -c "sed -i \"s/xwiki-sql-db-password/${SQL_USER_PASSWORD}/g\" /etc/xwiki/hibernate.cfg.xml"
}

Config_NFS_Xwiki(){
	export XWIKI_DATA_DIR="/var/lib/xwiki/data"
  export NFS_FILE_SHARE="${FILESTORE_IP_ADDRESS}:/xwiki_file_share"
  export MOUNT_FILE_SHARE="/mnt/xwiki_file_share"

  mkdir -p /mnt/xwiki_file_share
  sudo mount ${NFS_FILE_SHARE} ${MOUNT_FILE_SHARE}
  sudo test -d ${MOUNT_FILE_SHARE}/file || sudo mkdir -p  ${MOUNT_FILE_SHARE}/file
  sudo test -d ${MOUNT_FILE_SHARE}/extension/repository || sudo mkdir -p ${MOUNT_FILE_SHARE}/extension/repository
  sudo chown -R tomcat:tomcat ${MOUNT_FILE_SHARE}/*
  sudo umount ${MOUNT_FILE_SHARE}

  # For mount store/file to NFS share
  sudo test -d ${XWIKI_DATA_DIR}/store/file || sudo mkdir -p ${XWIKI_DATA_DIR}/store/file
  sudo mount ${NFS_FILE_SHARE}/file ${XWIKI_DATA_DIR}/store/file
  df -k | grep store || (echo "Failed to mount folder to NFS" ; exit 1)
  sudo chown -R tomcat:tomcat ${XWIKI_DATA_DIR}/store/

  sleep 3
}

#############
### Main ####
#############

Config_Xwiki
Config_NFS_Xwiki