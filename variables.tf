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
  default = "./withinworkspace-policy-rule.yaml"
}

variable "network_policy_rule_version" {
  type = string
  default = "v0"
}