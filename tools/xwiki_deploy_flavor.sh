#!/bin/bash
LOCATION=$1
XWIKI_SQL_USER_PASSWORD=$2
USER=migrate

DB_IP=$(gcloud sql instances list --filter="name ~ xwiki-${LOCATION}-db" --format="value(PRIVATE_ADDRESS)")

mkdir -p ${HOME}/.ssh/
ssh-keygen -q -t rsa -N '' -f ${HOME}/.ssh/google_compute_engine <<<y >/dev/null 2>&1

VM_01_NAME=$(gcloud compute instances list --filter="NAME ~ xwiki-${LOCATION}-group-autoscale-* AND STATUS=RUNNING" --format="value(NAME)" --limit=1)
ZONE=$(gcloud compute instances list --filter="name=${VM_01_NAME}" --format="value(ZONE)")

# Check if work folder exists to avoid timing issue
TIMEOUT=120
START_TIME=$(date +%s)
while true; do
  VM_01_NAME=$(gcloud compute instances list --filter="NAME ~ xwiki-${LOCATION}-group-autoscale-* AND STATUS=RUNNING" --format="value(NAME)" --limit=1)
  ZONE=$(gcloud compute instances list --filter="name=${VM_01_NAME}" --format="value(ZONE)")

  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME-START_TIME))
  if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
    echo "The xwiki folder was not found within $TIMEOUT seconds."
    exit 1
  fi
  echo "VM Zone: ${ZONE}"
  ZONE=$(gcloud compute instances list --filter="name=${VM_01_NAME}" --format="value(ZONE)")
  gcloud compute ssh ${USER}@${VM_01_NAME} --zone ${ZONE} --tunnel-through-iap -- "mount | grep \/var\/lib\/xwiki\/data\/store\/file"
  if [ $? -eq 0 ]; then
    echo "The xwiki store folder was found."
    break
  else
    echo "Checking xwiki store folder..."
    sleep 1
  fi
done

gcloud compute ssh ${USER}@${VM_01_NAME} --zone ${ZONE} --tunnel-through-iap --command="sudo su -c \"cd /home ; tar -zxvf file_14.10.4.tar.gz -C /var/lib/xwiki/data/store/ ; tar zxvf xwiki_mysql_db_bk_14.10.4.tar.gz \""
gcloud compute ssh ${USER}@${VM_01_NAME} --zone ${ZONE} --tunnel-through-iap --command="mysql -uxwiki -p${XWIKI_SQL_USER_PASSWORD} -h${DB_IP} xwiki < /home/xwiki_bk_14.10.sql"

VM_NAME_LIST=$(gcloud compute instances list --filter="name ~ xwiki-${LOCATION}-group-autoscale-* AND STATUS=RUNNING" --format="value(NAME)")
for vm in ${VM_NAME_LIST}; do
  vm_zone=$(gcloud compute instances list --filter="name=${vm}" --format="value(ZONE)")
  gcloud compute ssh ${USER}@${vm} --zone ${vm_zone} --tunnel-through-iap --command="sudo systemctl restart tomcat9"
done

gcloud compute project-info describe --format="value(commonInstanceMetadata.items.[ssh-keys])" > prj_all_key_list
REMOVE_KEY=$(cat ${HOME}/.ssh/google_compute_engine.pub)
grep -v "$REMOVE_KEY" prj_all_key_list > cloudbuild_key_removed_list
gcloud compute project-info add-metadata --metadata-from-file=ssh-keys=cloudbuild_key_removed_list