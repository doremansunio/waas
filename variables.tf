variable "project_name" {
  type = string
  default = "team-e"
}

variable "workspace_admins" {
  type    = list
  default = ["phani.kg@gmail.com"]
}

variable "cluster_name" {
  type = string
  default = "multi-eks1"
}
