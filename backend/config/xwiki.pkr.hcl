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

packer {
  required_plugins {
    googlecompute = {
      version = "1.0.16"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "xwiki" {
  project_id            = "${var.project_id}"
  image_storage_locations = [
    "${var.region}",
  ]
  zone              = "${var.zone}"
  image_name        = "${var.xwiki_img_name}"
  image_description = "${var.img_desc}"
  image_labels = {
    developer = "cienet"
  }
  image_family        = "xwiki"
  source_image_family = "ubuntu-2004-lts"
  ssh_username        = "root"
  network             = "default"
}

build {
  sources = ["sources.googlecompute.xwiki"]

  provisioner "file" {
    sources     = [
      "${var.file_sources_tcp}", 
      "${var.file_sources_hibernate}",
      "${var.file_sources_startup_sh}",
      "${var.file_deploy_flavor_sh}",
    ]
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars   = ["XWIKI_MIGRATE_FILE_BUCKET=${var.xwiki_migrate_file_bucket}",]
    script             = "${var.deploy_sh}"
  }

  post-processor "manifest" {
    output     = "xwiki-manifest.json"
    strip_path = true
  }
}
