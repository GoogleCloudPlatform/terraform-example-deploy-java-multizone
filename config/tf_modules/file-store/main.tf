resource "google_filestore_instance" "xwiki" {
  name     = "xwiki-${var.region}-file-share"
  tier     = "BASIC_HDD"
  location = "${var.zone}"
  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
  file_shares {
    capacity_gb = 1024
    name        = "xwiki_file_share"
  }
}