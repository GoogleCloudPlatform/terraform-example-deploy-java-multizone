#==============================BACKEND_SERVICE==============================#
resource "google_compute_backend_service" "xwiki_lb_http_bkend_vm_auto" {
  load_balancing_scheme = "EXTERNAL_MANAGED" //non-classic Global Load Balancer
  enable_cdn            = true
  cdn_policy {
    cache_key_policy {
      include_host         = true
      include_protocol     = true
      include_query_string = true
    }
    negative_caching  = false
    serve_while_stale = 0
  }
  name      = "g-${var.region}-xwiki-lb-http-bkend-vm-auto"
  port_name = "${var.region}-bkend-port"
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

#==============================FRONTEND==============================#
resource "google_compute_global_forwarding_rule" "xwiki_lb_http_frontend_ip" {
  load_balancing_scheme = "EXTERNAL_MANAGED" //non-classic Global Load Balancer
  name                  = "g-${var.region}-xwiki-lb-http-frontend-ip"
  ip_address            = var.lb_ip
  port_range            = "8080-8080"
  target                = google_compute_target_http_proxy.xwiki_lb_http_8080_target_proxy.self_link
}

resource "google_compute_target_http_proxy" "xwiki_lb_http_8080_target_proxy" {
  name    = "xwiki-lb-http-8080-target-proxy"
  url_map = google_compute_url_map.xwiki_lb_http_8080.self_link
}

resource "google_compute_url_map" "xwiki_lb_http_8080" {
  default_service = google_compute_backend_service.xwiki_lb_http_bkend_vm_auto.self_link
  name            = "g-${var.region}-xwiki-lb-http-8080"
}