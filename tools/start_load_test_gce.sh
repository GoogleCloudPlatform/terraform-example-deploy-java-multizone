#!/bin/bash

# Environment
TYPE=gce
THREAD=30
DATE="$(date +%Y-%m%d-%H%M)"
LOAD_TEST_FOLDER="jmeter-load-test-tools"

## Disable Sticky session
LB_IP=$(gcloud compute forwarding-rules list --filter="NAME ~ xwiki-lb-http-frontend-ip*" --format="value(IP_ADDRESS)")
#LB_IP="34.160.34.117"
BK_SERVICE=$(gcloud compute backend-services list --filter="NAME ~ xwiki-lb-http-bkend-vm-auto" --format="value(NAME)")
gcloud compute backend-services update ${BK_SERVICE} --session-affinity=None --global

# Downlowd & Deploy jmeter tools
wget -N https://storage.googleapis.com/${LOAD_TEST_FOLDER}/apache-jmeter-5.5.zip
sudo apt-get update -y
sudo apt-get install openjdk-11-jdk -y
sudo apt-get install unzip
test -d apache-jmeter-5.5 || unzip apache-jmeter-5.5.zip
JMETER_DIR="${PWD}/apache-jmeter-5.5"
test -d ${JMETER_DIR}/plan || mkdir ${JMETER_DIR}/plan

# Start to load test
JMETER_CONFIG="xwiki_load_test_${TYPE}_${THREAD}.jmx"
wget https://storage.googleapis.com/${LOAD_TEST_FOLDER}/${JMETER_CONFIG} -O ${JMETER_DIR}/plan/${JMETER_CONFIG}
sed -i "s/LOAD_BALANCER_IP/${LB_IP}/g" ${JMETER_DIR}/plan/${JMETER_CONFIG}
/bin/sh ${JMETER_DIR}/bin/jmeter -n -t ${JMETER_DIR}/plan/${JMETER_CONFIG} -l output_gcp_${DATE}.jtl -j jmeter_${DATE}.log

## Enable Sticky session
gcloud compute backend-services update ${BK_SERVICE} --session-affinity=CLIENT_IP --global
