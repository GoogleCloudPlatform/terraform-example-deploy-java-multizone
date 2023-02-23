output "xwiki_entrypoint_url" {
  description = "Shows the URL of XWiki's index page."
  value       = "http://${module.load_balancer.lb_global_ip}:8080/xwiki"
}

output "xwiki_mig_self_link" {
  description = "MIG hosting XWiki"
  value       = module.vm.xwiki_mig.self_link
}
