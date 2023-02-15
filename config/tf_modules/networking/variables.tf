variable "project_id" {
  description = "GCP project ID. e.g.: test-367504"
  type        = string
}

variable "region" {
  description = "The region chosen to be used. e.q.: us-west1"
  type        = string
}

variable "zones" {
  description = "Zones depend on the chosen region. e.q.: [us-west1-a, us-west1-b]"
  type        = list(string)
}

variable "firewall_source_ranges" {
  description = "The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format."
  type        = list(string)
  default     = []
}