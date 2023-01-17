variable "project_id" {
  description = "google cloud project id where the resource will be created."
  type        = string
}

variable "region" {
  description = "google cloud region where the resource will be created. ex: asia-east1, us-west1"
  type        = string
}

variable "xwiki_img_name" {
  description = "Name of Xwiki image build by Packer."
  type = string
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

variable "internal_addresses" {
  description = "A list of interal ip addresses will be created, The IP addresses must be \"inside\" the specified subnetwork. Every name will be asigned address by index automatically."
  type        = list(string)
}

variable "firewall_source_ranges" {
  description = "The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format."
  type        = list(string)
}