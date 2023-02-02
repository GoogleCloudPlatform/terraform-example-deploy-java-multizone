output "xwiki_entrypoint_url" {
  description = "Shows the URL of XWiki's index page."
  value       = "http://${module.load_balancer.lb_global_ip}:8080/xwiki"
}

output "xwiki_flavor_install_url" {
  description = "Shows the URL of XWiki's UI installation page."
  value       = "http://${module.vm.instance1.network_interface.0.access_config.0.nat_ip}:8080/xwiki"
}
