variable "region" {
  description = "The region that file-store will be created in, e.g.: asia-east1, us-west1"
  type        = string
}

variable "zone" {
  description = "Zone is used for filestore location, it depends on the region chosen. E.g.: us-west1-a"
  type        = string
}