locals {
  source_ranges = concat(
    [
      module.global_addresses.addresses[0],
    ],
    var.firewall_source_ranges
  )
}

resource "google_compute_network" "xwiki" {
  provider                = google
  name                    = "xwiki"
  auto_create_subnetworks = true
  project                 = var.project_id
}

module "global_addresses" {
  source  = "terraform-google-modules/address/google"
  version = "3.1.1"

  project_id = var.project_id
  region     = var.region
  // module default is INTERNAL. but resource default is EXTERNAL
  address_type = "EXTERNAL"
  global       = true
  names = [
    "xwiki-${var.region}-lb-http-8080-ip",
  ]
}

resource "google_compute_firewall" "http_rule" {
  name    = "xwiki-${var.region}-http-8080"
  network = google_compute_network.xwiki.name
  allow {
    protocol = "tcp"
    ports = [
      "8080",
    ]
  }
  source_ranges = local.source_ranges
  target_tags = [
    var.xwiki_vm_tag,
  ]
}

resource "google_compute_firewall" "ssh_rule" {
  name    = "xwiki-${var.region}-ssh"
  network = google_compute_network.xwiki.name
  allow {
    protocol = "tcp"
    ports = [
      "22",
    ]
  }
  source_ranges = ["35.235.240.0/20", ]
  target_tags = [
    var.xwiki_vm_tag,
  ]
}

resource "google_compute_router" "xwiki" {
  name    = "xwiki-router"
  region  = var.region
  network = google_compute_network.xwiki.name
}

resource "google_compute_router_nat" "xwiki" {
  name                               = "xwiki-router-nat"
  router                             = google_compute_router.xwiki.name
  region                             = google_compute_router.xwiki.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}