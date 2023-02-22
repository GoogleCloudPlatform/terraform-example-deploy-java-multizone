output "lb_global_ip" {
  description = "Frontend IP address of the load balancer"
  value       = google_compute_global_forwarding_rule.xwiki_lb_http_frontend.ip_address
}
