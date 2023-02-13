variable "project_id" {
  description = "google cloud project id where the resource will be created."
  type        = string
  validation {
    condition = var.project_id != ""
    error_message = "Error: project_id is required"
  }
}

# Not use
variable "region" {
  description = "google cloud region where the resource will be created. ex: asia-east1, us-west1"
  type        = string
}

variable "location" {
  description = "The location contains region, zone_codes(at least two zone codes), zone code depend on the region."
  type = object({
    region     = string
    zone_codes = list(string)
    }
  )
}

variable "availability_type" {
  description = "The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL)."
  type        = string
  validation {
    condition     = contains(["REGIONAL", "ZONAL"], var.availability_type)
    error_message = "Allowed values for type are \"REGIONAL\", \"ZONAL\"."
  }
}

variable "vm_sa_email" {
  description = "Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles."
  type        = string
  validation {
    condition = var.vm_sa_email != ""
    error_message = "Error: vm_sa_email is required"
  }
}

variable "xwiki_sql_user_password" {
  description = "Default password for user xwiki"
  type        = string
}

variable "firewall_source_ranges" {
  description = "The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format."
  type        = list(string)
}

variable "xwiki_img_info" {
  description = "Xwiki app image information."
  type = object({
    image_name = string
    image_project = string
  })
}
