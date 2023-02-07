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
  zone              = "${var.region}-${var.zone_code}"
  image_name        = "${var.xwiki_img_name}"
  image_description = "${var.img_desc}"
  image_labels = {
    developer = "cienet"
    team      = "gcps"
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
    ]
    destination = "/tmp/"
  }

  provisioner "shell" {
    script           = "${var.deploy_sh}"
  }

  post-processor "manifest" {
    output     = "xwiki-manifest.json"
    strip_path = true
  }
}