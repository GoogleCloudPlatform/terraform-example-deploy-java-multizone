output "global_addresses" {
  description = "List of global addresses managed by this module such as load balancer IP etc."
  value       = module.global_addresses.addresses
}
