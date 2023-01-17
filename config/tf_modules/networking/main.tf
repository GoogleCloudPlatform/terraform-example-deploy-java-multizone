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
  address_type = "EXTERNAL" // module default is INTERNAL. but resource default is EXTERNAL
  global       = true
  names = [
    "xwiki-${var.region}-lb-http-8080-ip",
  ]
}

module "xwiki_internal_addresses" { // module default is INTERNAL.
  source  = "terraform-google-modules/address/google"
  version = "3.1.1"

  project_id = var.project_id
  region     = var.region
  names = [
    "g-${var.region}-${var.zone_code1}-xwiki-01t-internal-static-ip",
    "g-${var.region}-${var.zone_code2}-xwiki-02t-internal-static-ip",
  ]
  addresses = var.internal_addresses
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
    "g-${var.region}-${var.zone_code1}-xwiki-01t",
    "g-${var.region}-${var.zone_code2}-xwiki-02t",
    "g-${var.region}-xwiki-autoscale",
  ]
}