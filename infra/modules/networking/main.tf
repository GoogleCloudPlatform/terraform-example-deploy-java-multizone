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

resource "google_compute_network" "xwiki" {
  provider                = google
  name                    = "xwiki-gce"
  auto_create_subnetworks = true
  project                 = var.project_id
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
  # Health check service ip and Load balancer ip
  source_ranges = var.firewall_source_ranges
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
  # IAP TCP forwarding IP range.
  source_ranges = ["35.235.240.0/20", ]
  target_tags = [
    var.xwiki_vm_tag,
  ]
}

resource "google_compute_firewall" "internal_rule" {
  name    = "xwiki-allow-internal"
  network = google_compute_network.xwiki.name
  allow {
    protocol = "tcp"
    ports = [
      "0-65535",
    ]
  }
  # xwiki VPC network internal IP range.
  source_ranges = ["10.128.0.0/9", ]
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
