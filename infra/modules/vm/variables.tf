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
}

variable "region" {
  description = "The region chosen to be used."
  type        = string
}

variable "zones" {
  description = "A list of zones that mig can be placed in. The list depends on the region chosen."
  type        = list(string)
}

variable "private_network_id" {
  description = "VPC id"
  type        = string
}

variable "xwiki_vm_tag" {
  description = "Tag for targeting FW rule"
  type        = string
}

variable "service_account" {
  description = "Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles."
  type = object({
    email  = string
    scopes = set(string)
  })
}

variable "startup_script" {
  description = "The startup script to run when instances start up"
  type        = any
  default     = ""
}

variable "xwiki_lb_port_name" {
  description = "Xwiki LB backend port name"
  type        = string
}

variable "xwiki_img_info" {
  description = "Xwiki app image information."
  type = object({
    image_name    = string
    image_project = string
  })
}

variable "labels" {
  description = "A map of key/value label pairs to assign to the resources."
  type        = map(string)
}
