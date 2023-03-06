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

resource "google_compute_backend_service" "xwiki_lb" {
  project               = var.project_id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  name                  = "xwiki-lb-http-bkend-vm-auto"
  port_name             = var.xwiki_lb_port_name
  backend {
    group           = var.xwiki_mig.instance_group
    max_utilization = 0.8
  }
  locality_lb_policy = "RING_HASH"
  session_affinity   = "CLIENT_IP"
  consistent_hash {
    minimum_ring_size = 1024
  }
  health_checks = [
    var.xwiki_mig.health_check_self_links[0],
  ]
}

resource "google_compute_global_forwarding_rule" "xwiki_lb_http_frontend" {
  project               = var.project_id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  name                  = "xwiki-lb-http-frontend"
  ip_address            = google_compute_global_address.xwiki.address
  port_range            = "80"
  target                = google_compute_target_http_proxy.xwiki_lb_http.self_link
}

resource "google_compute_global_address" "xwiki" {
  name = "xwiki-lb-http-ip"
}

resource "google_compute_target_http_proxy" "xwiki_lb_http" {
  project = var.project_id
  name    = "xwiki-lb-http-8080-target-proxy"
  url_map = google_compute_url_map.xwiki_lb_http.self_link
}

resource "google_compute_url_map" "xwiki_lb_http" {
  project         = var.project_id
  default_service = google_compute_backend_service.xwiki_lb.self_link
  name            = "xwiki-lb-http-8080"
}
