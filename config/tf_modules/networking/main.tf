locals {
  source_ranges = concat(
    [
      module.global_addresses.addresses[0],
    ],
    var.firewall_source_ranges
  )
}

module "global_addresses" {
  source  = "terraform-google-modules/address/google"
  version = "3.1.1"

  project_id   = var.project_id
  region       = var.region
  // module default is INTERNAL. but resource default is EXTERNAL
  address_type = "EXTERNAL"
  global       = true
  names = [
    "xwiki-${var.region}-lb-http-8080-ip",
  ]
}

resource "google_compute_firewall" "rules" {
  name    = "xwiki-${var.region}-fw-http-8080"
  network = "default"
  allow {
    protocol = "tcp"
    ports = [
      "8080",
    ]
  }
  source_ranges = local.source_ranges
  target_tags = [
    "g-${var.region}-xwiki-autoscale",
  ]
}

resource "google_compute_router" "xwiki_router" {
  name    = "xwiki-router"
  region  = var.region
  network = "default"
}

resource "google_compute_router_nat" "xwiki_nat" {
  name                               = "xwiki-router-nat"
  router                             = google_compute_router.xwiki_router.name
  region                             = google_compute_router.xwiki_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}