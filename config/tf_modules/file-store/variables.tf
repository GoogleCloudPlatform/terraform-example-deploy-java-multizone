variable "region" {
  description = "The region that file-store will be created in."
  type        = string
}

variable "zone" {
  description = "zone is used by filestore location, it depends on the region chosen."
  type        = string
}