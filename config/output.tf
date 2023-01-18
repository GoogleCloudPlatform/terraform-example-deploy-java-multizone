output "xwiki_entrypoint_url" {
  description = "To get load balencer ip, it can entry xwiki index page"
  value       = "http://${module.load_balancer.lb_global_ip}:8080/xwiki"
}