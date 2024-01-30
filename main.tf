terraform {
  required_providers {
    rafay = {
      source = "RafaySystems/rafay"
      version = "1.1.22"
    }
  }
}

provider "rafay" {
  # provider_config_file = "./rafay_config.json"
}

# resource "null_resource" "tfc_test" {
#   count = 10
#   provisioner "local-exec" {
#     command = "echo 'Test ${count.index}'"
#   }
# }
   
resource "rafay_project" "rafay_proj_new" {
  metadata {
    name        = var.project_name
    description = "terraform project"
  }
  spec {
    default = false
    # cluster_resource_quota {
    #   cpu_requests = "4000m"
    #   memory_requests = "4096Mi"
    #   cpu_limits = "8000m"
    #   memory_limits = "8192Mi"
    #   config_maps = "10"
    #   persistent_volume_claims = "5"
    #   services = "20"    
    #   pods = "200"
    #   replication_controllers = "10"
    #   services_load_balancers = "10"
    #   services_node_ports = "10"
    #   storage_requests = "100Gi"
    # }
    # default_cluster_namespace_quota {
    #   cpu_requests = "1000m"
    #   memory_requests = "1024Mi"
    #   cpu_limits = "2000m"
    #   memory_limits = "2048Mi"
    #   config_maps = "5"
    #   persistent_volume_claims = "2"
    #   services = "10"
    #   pods = "20"
    #   replication_controllers = "4"
    #   services_load_balancers = "4"
    #   services_node_ports = "4"
    #   storage_requests = "10Gi"
    # }
  }
}

resource "rafay_group" "group-Workspace" {
  depends_on = [rafay_project.rafay_proj_new]
  name        = "WrkspAdmin-grp-${var.project_name}"
  description = "Workspace Admin Group for ${var.project_name}"
  
}

resource "rafay_groupassociation" "group-association" {
  depends_on = [rafay_group.group-Workspace]
  group      = "WrkspAdmin-grp-${var.project_name}"
  project    = var.project_name
  roles = ["WORKSPACE_ADMIN"]
  add_users = var.workspace_admins
}

resource "rafay_cluster_sharing" "demo-terraform-specific" {
  depends_on = [rafay_project.rafay_proj_new]
  clustername = var.cluster_name
  project     = var.main_cluster_project_name
  sharing {
    all = false
    projects {
      name = var.project_name
    }    
  }
}

resource "rafay_namespace_network_policy_rule" "demo-withinworkspacerule" {
  depends_on = [ rafay_cluster_sharing.demo-terraform-specific ]
  metadata {
    name    = var.network_policy_rule_name
    project = var.project_name
  }
  spec {
    artifact {
      type = "Yaml"
      artifact { 
        paths { 
          name = var.network_policy_rule_filepath
        } 
      }
    }
    version = var.network_policy_rule_version
    sharing {
      enabled = false
    }
  }
}

resource "rafay_namespace_network_policy" "demo-withinworkspacepolicy" {
  depends_on = [rafay_namespace_network_policy_rule.demo-withinworkspacerule]
  metadata {
    name    = var.network_policy_name
    project = var.project_name
  }
  spec {
    version = var.network_policy_rule_version
    rules {
      name = var.network_policy_rule_name
      version = var.network_policy_rule_version
    }
    sharing {
      enabled = false
    }
  }
}