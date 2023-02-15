output "xwiki_entrypoint_url" {
  description = "Shows the URL of XWiki's index page."
  value       = "http://${module.load_balancer.lb_global_ip}:8080/xwiki"
}
