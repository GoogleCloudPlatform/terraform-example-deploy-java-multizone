region=$1
zone_code1=$2
zone_code2=$3
datadog_api_key=$4
datadog_app_key=$5

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
datadog_api_key = "$datadog_api_key"
datadog_app_key = "$datadog_app_key"
EOF