output "lb_global_ip" {
  description = "To get load balencer ip, it can entry xwiki index"
  value       = google_compute_global_forwarding_rule.xwiki_lb_http_frontend_ip.ip_address
}
