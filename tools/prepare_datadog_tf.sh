#!/bin/bash

datadog_api_key=$1
datadog_app_key=$2


if [[ -z $datadog_api_key || -z $datadog_app_key ]]; then
  echo "Datadog key not set, exit"
  exit 0
fi

# Append datadog variable to terraform.tfvars
cat << EOF >> ../config/terraform.tfvars
datadog_api_key = "$datadog_api_key"
datadog_app_key = "$datadog_app_key"
EOF

# Append datadog variable to provider.tf
cat << EOF >> ../config/provider.tf

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
EOF

# Append datadog variable to variable.tf
cat << \EOF >> ../config/variables.tf


variable "datadog_api_key" {
  description = "Datadog API Key used to create resources."
  type        = string
  sensitive   = true
  validation {
    condition = var.datadog_api_key != ""
    error_message = "Error: datadog_api_key is required"
  }
}

variable "datadog_app_key" {
  description = "Datadog App Key."
  type        = string
  sensitive   = true
  validation {
    condition = var.datadog_app_key != ""
    error_message = "Error: datadog_app_key is required"
  }
}
EOF

# Generate datadog terraform code to datadog.tf
cat << \EOF > ../config/datadog.tf
resource "google_service_account" "datadog_account" {
  depends_on = [
    module.project_services
  ]
  account_id = "datadog"
}

resource "google_service_account_key" "datadog_key" {
  service_account_id = google_service_account.datadog_account.name
}

resource "google_project_iam_member" "datadog_viewer_permission" {
  project = google_service_account.datadog_account.project
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.datadog_account.email}"
}

resource "datadog_integration_gcp" "gcp_project_integration" {
  depends_on = [
    google_service_account.datadog_account,
    google_service_account_key.datadog_key,
    google_project_iam_member.datadog_viewer_permission,
  ]
  project_id     = jsondecode(base64decode(google_service_account_key.datadog_key.private_key))["project_id"]
  private_key    = jsondecode(base64decode(google_service_account_key.datadog_key.private_key))["private_key"]
  private_key_id = jsondecode(base64decode(google_service_account_key.datadog_key.private_key))["private_key_id"]
  client_email   = jsondecode(base64decode(google_service_account_key.datadog_key.private_key))["client_email"]
  client_id      = jsondecode(base64decode(google_service_account_key.datadog_key.private_key))["client_id"]
}
EOF
