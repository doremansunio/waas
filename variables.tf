variable "central_pool_name" {
  type = string
  default = "mm-project-1"
}

variable "project_name" {
  type = string
  default = "team-q"
} 

variable "cluster_name" {
  type = string
  default = "eks-cluster-1"
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
