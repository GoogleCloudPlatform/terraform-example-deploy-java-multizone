#! /bin/bash

region=$1
zone_code1=$2
zone_code2=$3
xwiki_image_project=$4
xwiki_image_name=$5

if [ -z $xwiki_image_project ]; then
  echo "xwiki project image info empty, set default value"
  xwiki_image_project="migrate-legacy-java-app-gce"
  xwiki_image_name="us-west1-xwiki-01t-img-3afbbd02-4c92-470c-8fe2-659bdbff1a74"
fi

cat << EOF > ../config/terraform.tfvars
availability_type = "REGIONAL"
firewall_source_ranges = [
  //Health check service ip
  "130.211.0.0/22",
  "35.191.0.0/16",
  // Public to network
  "0.0.0.0/0",
]
location = {
  region     = "$region"
  zone_codes = ["$zone_code1", "$zone_code2"]
}
xwiki_img_info = {
    image_project = "$xwiki_image_project"
    image_name = "$xwiki_image_name"
}
EOF