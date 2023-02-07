#!/bin/bash
VM_01_NAME="xwiki-01t"
USER=migrate
DB_NAME="xwiki"
#DB_IP=$(gcloud sql instances list | grep -A 5 ${DB_NAME} | grep PRIVATE_ADDRESS | cut -d ":" -f2 | sed 's/\ //g')
DB_IP=$(gcloud sql instances list --filter="name ~ ${DB_NAME}" --format="value(PRIVATE_ADDRESS)")

#VM_01_NAME_EXTERNAL_IP=$(gcloud compute instances list | grep -A 5 ${VM_01_NAME} | grep EXTERNAL_IP | cut -d ":" -f2 | sed 's/\ //g')
VM_01_NAME_EXTERNAL_IP=$(gcloud compute instances list --filter="name ~ ${VM_01_NAME}" --format="value(EXTERNAL_IP)")
VM_01_FULLNAME=$(gcloud compute instances list --filter="name ~ ${VM_01_NAME}" --format="value(NAME)")
echo $VM_01_NAME_EXTERNAL_IP

mkdir -p ${HOME}/.ssh/
ssh-keygen -q -t rsa -N '' -f ${HOME}/.ssh/id_rsa <<<y >/dev/null 2>&1

sed -i "s/ssh-rsa/${USER}:ssh-rsa/g" ${HOME}/.ssh/id_rsa.pub

#ZONE=$(gcloud compute instances list | grep -A 5 ${VM_01_NAME} | grep ZONE | cut -d ":" -f2 | sed 's/\ //g')
ZONE=$(gcloud compute instances list --filter="name ~ ${VM_01_NAME}" --format="value(ZONE)")

gcloud compute instances add-metadata ${VM_01_FULLNAME} --metadata-from-file ssh-keys=${HOME}/.ssh/id_rsa.pub --zone=${ZONE}

ssh -i ${HOME}/.ssh/id_rsa -o "StrictHostKeyChecking no" ${USER}@${VM_01_NAME_EXTERNAL_IP} "sudo su -c \"cd /home ; tar -zxvf file_14.10.4.tar.gz -C /var/lib/xwiki/data/store/ ; tar zxvf xwiki_mysql_db_bk_14.10.4.tar.gz \""
ssh -i ${HOME}/.ssh/id_rsa -o "StrictHostKeyChecking no" ${USER}@${VM_01_NAME_EXTERNAL_IP} "mysql -uxwiki -pxwiki -h${DB_IP} xwiki < /home/xwiki_bk_14.10.sql"

touch ${HOME}/.ssh/id_rsa.pub.clear
echo "$USER:ssh-rsa" > ${HOME}/.ssh/id_rsa.pub.clear

gcloud compute instances add-metadata ${VM_01_FULLNAME} --metadata-from-file ssh-keys=${HOME}/.ssh/id_rsa.pub.clear --zone=${ZONE}