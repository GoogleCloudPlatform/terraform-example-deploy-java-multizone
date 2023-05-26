/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "GCP project ID."
  type        = string
  validation {
    condition     = var.project_id != ""
    error_message = "Error: project_id is required"
  }
}

variable "region" {
  description = "Compute Region to deploy to."
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "Compute Zones to deploy to."
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b"]
}

variable "availability_type" {
  description = "The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL)."
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "ZONAL"], var.availability_type)
    error_message = "Allowed values for type are \"REGIONAL\", \"ZONAL\"."
  }
}

variable "firewall_source_ranges" {
  description = "The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format."
  type        = list(string)
  default = [
    //Health check service ip
    "130.211.0.0/22",
    "35.191.0.0/16",
  ]
}

variable "xwiki_img_info" {
  description = "Xwiki app image information."
  type = object({
    image_project = string
    image_name    = string
  })
  default = {
    image_project = "hsa-public"
    image_name    = "hsa-xwiki-vm-img-latest"
  }
}

variable "labels" {
  description = "A map of key/value label pairs to assign to the resources."
  type        = map(string)

  default = {
    app = "terraform-example-deploy-java-gce"
  }
}
