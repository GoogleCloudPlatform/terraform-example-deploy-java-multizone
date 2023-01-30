variable "region" {
  description = "The region will be created the file-store in, ex: asia-east1, us-west1"
  type        = string
}

variable "zone_code" {
  description = "The zone-code is used to filestore location, it depends on the region. ex: a"
  type        = string
  default     = "a"
}