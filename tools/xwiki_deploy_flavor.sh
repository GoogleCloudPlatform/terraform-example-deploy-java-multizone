#!/bin/bash
LOCATION=$1
XWIKI_SQL_USER_PASSWORD=$2
VM_01_NAME=$(gcloud compute instances list --filter="NAME ~ xwiki-group-autoscale*" --format="value(NAME)" --limit=1)
USER=migrate
DB_IP=$(gcloud sql instances list --filter="name ~ xwiki-${LOCATION}-db" --format="value(PRIVATE_ADDRESS)")
VM_01_NAME_INTERNAL_IP=$(gcloud compute instances list --filter="name ~ ${VM_01_NAME}" --format="value(INTERNAL_IP)")
VM_01_FULLNAME=$(gcloud compute instances list --filter="name ~ ${VM_01_NAME}" --format="value(NAME)")

mkdir -p ${HOME}/.ssh/
ssh-keygen -q -t rsa -N '' -f ${HOME}/.ssh/google_compute_engine <<<y >/dev/null 2>&1
ZONE=$(gcloud compute instances list --filter="name ~ ${VM_01_FULLNAME}" --format="value(ZONE)")
gcloud compute instances add-metadata  ${VM_01_FULLNAME} --metadata-from-file ssh-keys=${HOME}/.ssh/google_compute_engine.pub --zone=${ZONE}

# Check if work folder exists to avoid timing issue
TIMEOUT=120
START_TIME=$(date +%s)
while true; do
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME-START_TIME))
  if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
    echo "The xwiki folder was not found within $TIMEOUT seconds."
    exit 1
  fi
  gcloud compute ssh ${USER}@${VM_01_FULLNAME} --zone ${ZONE} --tunnel-through-iap -- "mount | grep \/var\/lib\/xwiki\/data\/store\/file"
  if [ $? -eq 0 ]; then
    echo "The xwiki store folder was found."
    break
  else
    echo "Checking xwiki store folder..."
  fi
done

gcloud compute ssh ${USER}@${VM_01_FULLNAME} --zone ${ZONE} --tunnel-through-iap -- "sudo su -c \"cd /home ; tar -zxvf file_14.10.4.tar.gz -C /var/lib/xwiki/data/store/ ; tar zxvf xwiki_mysql_db_bk_14.10.4.tar.gz \""
gcloud compute ssh ${USER}@${VM_01_FULLNAME} --zone ${ZONE} --tunnel-through-iap -- "mysql -uxwiki -p${XWIKI_SQL_USER_PASSWORD} -h${DB_IP} xwiki < /home/xwiki_bk_14.10.sql"

touch ${HOME}/.ssh/google_compute_engine.clear
echo "$USER:ssh-rsa" > ${HOME}/.ssh/google_compute_engine.clear
gcloud compute instances add-metadata ${VM_01_FULLNAME} --metadata-from-file ssh-keys=${HOME}/.ssh/google_compute_engine.clear --zone=${ZONE}