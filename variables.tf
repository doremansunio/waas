variable "central_pool_name" {
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
  default = "deny-all-for-ns-policy"
}

variable "network_policy_rule_name" {
  type = string
  default = "deny-all-for-ns-policy-rule"
}

variable "network_policy_rule_filepath" {
  type = string
  default = "file://deny-all-for-namespace.yaml"
}

variable "network_policy_rule_version" {
  type = string
  default = "v1"
}