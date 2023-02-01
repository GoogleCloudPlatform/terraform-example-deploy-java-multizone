variable "project_id" {
  description = "google cloud project id where the resource will be created."
  type        = string
}

# Not use
variable "region" {
  description = "google cloud region where the resource will be created. ex: asia-east1, us-west1"
  type        = string
}

# Not use
variable "zone_code1" {
  description = "The zone-code is used to instance 01, it depends on the region. ex: a"
  type        = string
  default     = "a"
}

# Not use
variable "zone_code2" {
  description = "The zone-code is used to instance 02, it depends on the region. ex: b"
  type        = string
  default     = "b"
}

variable "location" {
  description = "The location contains region, zone_codes(at least two zone codes), zone code depend on the region."
  type = object({
    region     = string
    zone_codes = list(string)
    }
  )
}

variable "xwiki_img_name" {
  description = "Name of Xwiki image build by Packer."
  type        = string
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
}

variable "firewall_source_ranges" {
  description = "The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format."
  type        = list(string)
}

variable "datadog_api_key" {
  description = "Datadog API Key used to create resources."
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog App Key."
  type        = string
  sensitive   = true
}