#! /bin/bash

REGION=$1
ZONE1=$2
ZONE2=$3
XWIKI_IMAGE_PROJECT=$4
XWIKI_IMAGE_NAME=$5

if [ -z $XWIKI_IMAGE_PROJECT ]; then
  echo "xwiki project image info empty, set default value"
  XWIKI_IMAGE_PROJECT="migrate-legacy-java-app-gce"
  XWIKI_IMAGE_NAME="hsa-xwiki-vm-img-latest"
fi

cat << EOF > ../infra/terraform.tfvars
availability_type = "REGIONAL"
firewall_source_ranges = [
  //Health check service ip
  "130.211.0.0/22",
  "35.191.0.0/16",
]
location = {
  region     = "$REGION"
  zones      = ["$ZONE1", "$ZONE2"]
}
xwiki_img_info = {
    image_project = "$XWIKI_IMAGE_PROJECT"
    image_name    = "$XWIKI_IMAGE_NAME"
}
EOF
