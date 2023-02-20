variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "xwiki_img_name" {
  type = string
}

variable "img_desc" {
  type = string
}

variable "file_sources_tcp" {
  type    = string
  default = "tcp_gcp.xml"
}

variable "file_sources_hibernate" {
  type    = string
  default = "hibernate_gcp.cfg.xml"
}

variable "file_sources_startup_sh" {
  type    = string
  default = "../tools/xwiki_startup.sh"
}

variable "deploy_sh" {
  type    = string
  default = "../tools/xwiki_manual_deploy_gcp.sh"
}

variable "xwiki_migrate_file_bucket" {
  type    = string
  default = ""
}