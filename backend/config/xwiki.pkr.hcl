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