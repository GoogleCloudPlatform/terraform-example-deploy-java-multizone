// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "xwiki_img_name" {
  type = string
}

variable "img_desc" {
  type = string
}

variable "file_sources_tcp" {
  type    = string
  default = "tcp_gcp.xml"
}

variable "file_sources_hibernate" {
  type    = string
  default = "hibernate_gcp.cfg.xml"
}

variable "file_sources_startup_sh" {
  type    = string
  default = "../tools/xwiki_startup.sh"
}

variable "file_deploy_flavor_sh" {
  type    = string
  default = "../tools/xwiki_deploy_flavor.sh"
}

variable "deploy_sh" {
  type    = string
  default = "../tools/xwiki_manual_deploy_gcp.sh"
}

variable "xwiki_migrate_file_bucket" {
  type    = string
  default = ""
}
