variable "project_id" {
  description = "The project ID will be created the address in. ex: datadogtest-367504"
  type        = string
}

variable "region" {
  description = "The region will be created the address in, ex: asia-east1, us-west1"
  type        = string
}

variable "zone_code1" {
  description = "It depends on the region. ex: a"
  type        = string
  default     = "a"
}

variable "zone_code2" {
  description = "It depends on the region. ex: b"
  type        = string
  default     = "b"
}

variable "firewall_source_ranges" {
  description = "The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format."
  type        = list(string)
  default     = []
}