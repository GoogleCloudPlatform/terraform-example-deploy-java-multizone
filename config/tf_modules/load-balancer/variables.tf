variable "project_id" {
  description = "GCP project ID in which the auto-scaler group is created in."
  type        = string
}

variable "region" {
  description = "The region chosen to be used by the instance-group."
  type        = string
}

variable "xwiki_mig" {
  description = "Xwiki managed instance group"
  type        = any
}

variable "lb_ip" {
  description = "The IP address for load-balancer."
  type        = string
}
