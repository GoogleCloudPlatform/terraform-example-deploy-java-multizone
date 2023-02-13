#!/bin/bash
LOCATION=$1
XWIKI_SQL_USER_PASSWORD=$2
VM_01_NAME="xwiki-01t"
USER=migrate
DB_IP=$(gcloud sql instances list --filter="name ~ xwiki-${LOCATION}-db" --format="value(PRIVATE_ADDRESS)")
VM_01_NAME_EXTERNAL_IP=$(gcloud compute instances list --filter="name ~ ${VM_01_NAME}" --format="value(EXTERNAL_IP)")
VM_01_FULLNAME=$(gcloud compute instances list --filter="name ~ ${VM_01_NAME}" --format="value(NAME)")

mkdir -p ${HOME}/.ssh/
ssh-keygen -q -t rsa -N '' -f ${HOME}/.ssh/id_rsa <<<y >/dev/null 2>&1

sed -i "s/ssh-rsa/${USER}:ssh-rsa/g" ${HOME}/.ssh/id_rsa.pub
ZONE=$(gcloud compute instances list --filter="name ~ ${VM_01_NAME}" --format="value(ZONE)")
gcloud compute instances add-metadata ${VM_01_FULLNAME} --metadata-from-file ssh-keys=${HOME}/.ssh/id_rsa.pub --zone=${ZONE}

# Check if work folder exists to avoid timing issue
TIMEOUT=60
START_TIME=$(date +%s)

while true; do
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME-START_TIME))
  if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
    echo "The xwiki folder was not found within $TIMEOUT seconds."
    exit 1
  fi
  ssh -i ${HOME}/.ssh/id_rsa -o "StrictHostKeyChecking no" -o ConnectionAttempts=30 ${USER}@${VM_01_NAME_EXTERNAL_IP} "mount | grep \/var\/lib\/xwiki\/data\/store\/file"
  if [ $? -eq 0 ]; then
    echo "The xwiki store folder was found."
    break
  fi
done

ssh -i ${HOME}/.ssh/id_rsa -o "StrictHostKeyChecking no" ${USER}@${VM_01_NAME_EXTERNAL_IP} "sudo su -c \"cd /home ; tar -zxvf file_14.10.4.tar.gz -C /var/lib/xwiki/data/store/ ; tar zxvf xwiki_mysql_db_bk_14.10.4.tar.gz \""
ssh -i ${HOME}/.ssh/id_rsa -o "StrictHostKeyChecking no" ${USER}@${VM_01_NAME_EXTERNAL_IP} "mysql -uxwiki -p${XWIKI_SQL_USER_PASSWORD} -h${DB_IP} xwiki < /home/xwiki_bk_14.10.sql"

touch ${HOME}/.ssh/id_rsa.pub.clear
echo "$USER:ssh-rsa" > ${HOME}/.ssh/id_rsa.pub.clear

gcloud compute instances add-metadata ${VM_01_FULLNAME} --metadata-from-file ssh-keys=${HOME}/.ssh/id_rsa.pub.clear --zone=${ZONE}