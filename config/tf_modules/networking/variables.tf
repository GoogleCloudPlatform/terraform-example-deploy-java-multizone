variable "project_id" {
  description = "GCP project ID. e.g.: test-367504"
  type        = string
}

variable "region" {
  description = "The region chosen to be used. e.q.: us-west1"
  type        = string
}

variable "zone_code1" {
  description = "Code depending on the chosen zone. e.q.: a"
  type        = string
  default     = "a"
}

variable "zone_code2" {
  description = "Code depending on the chosen zone. e.q.: b"
  type        = string
  default     = "b"
}

variable "firewall_source_ranges" {
  description = "The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format."
  type        = list(string)
  default     = []
}