#==============================BACKENDS==============================#
resource "google_compute_instance_group" "group_1" {
  name = "g-${var.region}-${var.zone_code1}-group-manual"
  named_port {
    name = "${var.region}-bkend-port" //same as google_compute_backend_service port_name
    port = 8080
  }
  zone = "${var.region}-${var.zone_code1}"
  instances = [
    var.vm1.id,
  ]
}

resource "google_compute_instance_group" "group_2" {
  name = "g-${var.region}-${var.zone_code2}-group-manual"
  named_port {
    name = "${var.region}-bkend-port" //same as google_compute_backend_service port_name
    port = 8080
  }
  zone = "${var.region}-${var.zone_code2}"
  instances = [
    var.vm2.id,
  ]
}

module "img" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "7.9.0"

  project_id        = var.project_id
  mig_name          = "g-${var.region}-group-autoscale"
  hostname          = "g-${var.region}-group-autoscale"
  instance_template = var.template
  region            = var.region
  distribution_policy_zones = [
    "${var.region}-${var.zone_code1}",
    "${var.region}-${var.zone_code2}"
  ]
  autoscaling_enabled = true
  max_replicas        = 10
  min_replicas        = 1
  cooldown_period     = 120
  autoscaler_name     = "autoscaler"
  autoscaling_cpu = [
    {
      target = 0.5
    },
  ]
  health_check_name = "xwiki-healthcheck-http-8080"
  health_check = {
    type                = "tcp"
    port                = 8080
    proxy_header        = "NONE"
    request             = ""
    response            = ""
    check_interval_sec  = 5
    timeout_sec         = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    host                = ""
    initial_delay_sec   = 300
    request_path        = "/"
  }
  named_ports = [
    {
      name = "${var.region}-bkend-port" //same as google_compute_backend_service port_name
      port = 8080
    },
  ]
}

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
    group           = module.img.instance_group
    max_utilization = 0.8
  }
  backend {
    group           = google_compute_instance_group.group_1.self_link
    max_utilization = 0.8
  }
  backend {
    group           = google_compute_instance_group.group_2.self_link
    max_utilization = 0.8
  }
  locality_lb_policy = "RING_HASH"
  session_affinity = "CLIENT_IP"
  consistent_hash {
    minimum_ring_size = 1
  }
  health_checks = [
    module.img.health_check_self_links[0],
  ]
}

#==============================FRONTEND==============================#
resource "google_compute_global_forwarding_rule" "xwiki_lb_http_frontend_ip" {
  load_balancing_scheme = "EXTERNAL_MANAGED" //non-classic Global Load Balancer
  name                  = "g-${var.region}-lb-http-frontend-ip"
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