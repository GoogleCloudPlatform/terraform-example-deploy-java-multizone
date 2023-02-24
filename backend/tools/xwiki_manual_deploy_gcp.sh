#! /bin/bash
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


Install(){
	echo "-----Configuring apt-get-----"
	sudo wget https://maven.xwiki.org/xwiki-keyring.gpg -O /usr/share/keyrings/xwiki-keyring.gpg
	sudo wget "https://maven.xwiki.org/stable/xwiki-stable.list" -O /etc/apt/sources.list.d/xwiki-stable.list
	sudo apt-get update

	echo "-----Installing Network Tools-----"
	sudo apt-get install net-tools nfs-common -y

	echo "-----Installing MySQL-----"
	sudo apt-get -y install mysql-client-core-8.0

	echo "-----Installing XWiki-----"
  sudo wget https://maven.xwiki.org/releases/org/xwiki/platform/xwiki-platform-distribution-debian-tomcat9-common/14.10.4/xwiki-platform-distribution-debian-tomcat9-common-14.10.4.deb
  sudo wget https://maven.xwiki.org/releases/org/xwiki/platform/xwiki-platform-distribution-debian-common/14.10.4/xwiki-platform-distribution-debian-common-14.10.4.deb
  sudo apt-get install -y -f ./xwiki-platform-distribution-debian-common-14.10.4.deb
  sudo apt-get install -y -f ./xwiki-platform-distribution-debian-tomcat9-common-14.10.4.deb

}

#############
### Main ####
#############

cloud-init status -w
Install
sudo cp /tmp/tcp_gcp.xml /usr/lib/xwiki/WEB-INF/observation/remote/jgroups/tcp.xml
sudo cp /tmp/hibernate_gcp.cfg.xml /etc/xwiki/hibernate.cfg.xml
sudo cp /tmp/xwiki_startup.sh /home/xwiki_startup.sh
sudo cp /tmp/xwiki_deploy_flavor.sh /home/xwiki_deploy_flavor.sh

if [ -z $XWIKI_MIGRATE_FILE_BUCKET ]; then
  echo "xwiki migrate file bucket empty"
  XWIKI_MIGRATE_FILE_BUCKET="legacy-xwiki-installed-flavor"
fi

gsutil -m cp \
  "gs://$XWIKI_MIGRATE_FILE_BUCKET/xwiki_14.10.4_flavor/extension_14.10.4.tar.gz" \
  "gs://$XWIKI_MIGRATE_FILE_BUCKET/xwiki_14.10.4_flavor/file_14.10.4.tar.gz" \
  "gs://$XWIKI_MIGRATE_FILE_BUCKET/xwiki_14.10.4_flavor/xwiki_mysql_db_bk_14.10.4.tar.gz" \
  /home/
sudo tar xf /home/extension_14.10.4.tar.gz -C /var/lib/xwiki/data/
