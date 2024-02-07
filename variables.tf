variable "main_cluster_project_name" {
  type = string
  default = "centralpool"
}

variable "project_name" {
  type = string
  default = "team-q"
} 

variable "cluster_name" {
  type = string
  default = "multi-eks1"
}

variable "workspace_admins" {
  type    = list
  default = ["phani.kg@gmail.com"]
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
  default = "file://withinworkspace-policy-rule.yaml"
}

variable "network_policy_rule_version" {
  type = string
  default = "v1"
}