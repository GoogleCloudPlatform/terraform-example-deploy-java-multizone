#!/bin/bash

LB_IP="$(gcloud compute forwarding-rules list --format="value(IP_ADDRESS)")"
#LB_IP="$(gcloud compute forwarding-rules list | grep -A 3 frontend | grep IP_ADDRESS | cut -d ":" -f2 | sed 's/\ //g')"

BK_SERVICE="$(gcloud compute backend-services list | grep NAME | cut -d ":" -f2)"
gcloud compute backend-services update ${BK_SERVICE} --session-affinity=None --global

#AUTO_VM=$(gcloud compute instances list | grep autoscale)
#VM_02=$(gcloud compute instances list | grep xwiki-02)
#AUTO_VM_ZONE=$(gcloud compute instances list | grep -A 5 xwiki-02 | grep ZONE)
#VM_02_ZONE=$(gcloud compute instances list | grep -A 5 autoscale | grep ZONE)


#gcloud compute instances reset --zone=

wget -N https://storage.googleapis.com/jmeter-load-test-2023013117/apache-jmeter-5.5.zip
#wget -N https://storage.googleapis.com/jmeter-load-test-2023013117/run_load_test_v1.sh
#sudo apt-get update -y
#sudo apt-get install openjdk-11-jdk -y
#sudo apt-get install unzip
test -d apache-jmeter-5.5 || unzip apache-jmeter-5.5.zip


TYPE=GCE

JMETER_DIR="${PWD}/apache-jmeter-5.5"
test -d ${JMETER_DIR}/plan || mkdir ${JMETER_DIR}/plan
DATE="$(date +%Y-%m%d-%H%M)"

case $TYPE in
       "GCE")
            wget https://storage.googleapis.com/jmeter-load-test-2023013117/xwiki_load_test_30.jmx -O ./xwiki_load_test_30.jmx
            cp xwiki_load_test_30.jmx ${JMETER_DIR}/plan/
            JMETER_CONFIG="${JMETER_DIR}/plan/xwiki_load_test_30.jmx"
            ;;

       "GKE")
            wget https://storage.googleapis.com/jmeter-load-test-2023013117/xwiki_load_test_gke_30.jmx -O ./xwiki_load_test_gke_30.jmx
            cp xwiki_load_test_gke_30.jmx ${JMETER_DIR}/plan/
            JMETER_CONFIG="${JMETER_DIR}/plan/xwiki_load_test_gke_30.jmx"
            ;;
esac


sed -i "s/LOAD_BALANCER_IP/${LB_IP}/g" ${JMETER_CONFIG}
/bin/sh ${JMETER_DIR}/bin/jmeter -n -t ${JMETER_CONFIG} -l output_gcp_${DATE}.jtl -j jmeter_${DATE}.log

#sh -x run_load_test_v1.sh "${LB_IP}" "GKE" &
