output "global_addresses" {
  description = "List of global_addresses managed by this module such as load-balancer ip etc."
  value       = module.global_addresses.addresses
}