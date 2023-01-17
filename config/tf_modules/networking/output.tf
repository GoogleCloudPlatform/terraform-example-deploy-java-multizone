output "internal_ips" {
  description = "List of internal_ips managed by this module."
  value       = module.xwiki_internal_addresses.addresses
}

output "global_addresses" {
  description = "List of global_addresses managed by this module such as load-balancer ip etc."
  value       = module.global_addresses.addresses
}