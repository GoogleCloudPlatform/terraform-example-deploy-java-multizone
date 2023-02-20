variable "region" {
  description = "The region that filestore will be created in."
  type        = string
}

variable "zone" {
  description = "zone is used by filestore location, it depends on the region chosen."
  type        = string
}

variable "private_network" {
  type = any
}
