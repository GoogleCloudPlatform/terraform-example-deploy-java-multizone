#!/bin/bash
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


DATADOG_API_KEY=$1
DATADOG_APP_KEY=$2


if [[ -z $DATADOG_API_KEY || -z $DATADOG_APP_KEY ]]; then
  echo "Datadog key not set, exit"
  exit 0
fi

# Append datadog variable to terraform.tfvars
cat << EOF >> ../infra/terraform.tfvars
datadog_api_key = "$DATADOG_API_KEY"
datadog_app_key = "$DATADOG_APP_KEY"
EOF

# Append datadog variable to provider.tf
cat << EOF >> ../infra/provider.tf

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
EOF

# Append datadog variable to variable.tf
cat << \EOF >> ../infra/variables.tf


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
cat << \EOF > ../infra/datadog.tf
resource "google_service_account" "datadog" {
  depends_on = [
    module.project_services
  ]
  account_id = "xwiki-datadog"
}

resource "google_service_account_key" "datadog" {
  service_account_id = google_service_account.datadog.name
}

resource "google_project_iam_member" "datadog_permission" {
  project = google_service_account.datadog.project
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.datadog.email}"
}

resource "datadog_integration_gcp" "xwiki" {
  depends_on = [
    google_service_account.datadog,
    google_service_account_key.datadog,
    google_project_iam_member.datadog_permission,
  ]
  project_id     = jsondecode(base64decode(google_service_account_key.datadog.private_key))["project_id"]
  private_key    = jsondecode(base64decode(google_service_account_key.datadog.private_key))["private_key"]
  private_key_id = jsondecode(base64decode(google_service_account_key.datadog.private_key))["private_key_id"]
  client_email   = jsondecode(base64decode(google_service_account_key.datadog.private_key))["client_email"]
  client_id      = jsondecode(base64decode(google_service_account_key.datadog.private_key))["client_id"]
}
EOF
