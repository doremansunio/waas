variable "project_name" {
  type = string
  default = "team-k"
}

variable "workspace_admins" {
  type    = list
  default = ["phani.kg@gmail.com"]
}

variable "workspace_shared_list" {
  type    = list
  default = ["team-a","team-b","team-e", "team-k"]
}

variable "cluster_name" {
  type = string
  default = "multi-eks1"
}

variable "main_cluster_project_name" {
  type = string
  default = "team-a"
}

variable "network_policy_name" {
  type = string
  default = "withinworkspace-policy"
}

variable "network_policy_rule_name" {
  type = string
  default = "withinworkspace-policy-rule"
}

variable "network_policy_rule_filepath" {
  type = string
  default = "file://test.yaml"
}

variable "network_policy_rule_version" {
  type = string
  default = "v0"
}