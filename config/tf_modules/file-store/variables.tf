variable "region" {
  description = "The region that file-store will be created in, e.g.: asia-east1, us-west1"
  type        = string
}

variable "zone_code" {
  description = "zone-code is used for filestore location, code depends on the region chosen. E.g.: a"
  type        = string
  default     = "a"
}