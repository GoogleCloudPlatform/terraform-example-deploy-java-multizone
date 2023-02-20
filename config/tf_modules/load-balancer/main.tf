resource "google_compute_backend_service" "xwiki_lb" {
  load_balancing_scheme = "EXTERNAL_MANAGED"
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
  name      = "xwiki-lb-http-bkend-vm-auto"
  port_name = var.xwiki_lb_port_name
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
  load_balancing_scheme = "EXTERNAL_MANAGED"
  name                  = "xwiki-lb-http-frontend"
  ip_address            = var.lb_ip
  port_range            = "8080-8080"
  target                = google_compute_target_http_proxy.xwiki_lb_http.self_link
}

resource "google_compute_target_http_proxy" "xwiki_lb_http" {
  name    = "xwiki-lb-http-8080-target-proxy"
  url_map = google_compute_url_map.xwiki_lb_http.self_link
}

resource "google_compute_url_map" "xwiki_lb_http" {
  default_service = google_compute_backend_service.xwiki_lb.self_link
  name            = "xwiki-lb-http-8080"
}