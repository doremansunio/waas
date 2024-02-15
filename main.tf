terraform {
  required_providers {
    rafay = {
      source = "RafaySystems/rafay"
      version = "1.1.22"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }  
  }
}

provider "rafay" {
  # provider_config_file = "./rafay_config.json"
}

provider "github" {    
}

# resource "null_resource" "tfc_test" {
#   count = 10
#   provisioner "local-exec" {
#     command = "echo 'Test ${count.index}'"
#   }
# }

# resource "local_file" "netpolicy-file" {
#   //depends_on = [ rafay_cluster_sharing.demo-terraform-specific ]
#   //depends_on = [rafay_groupassociation.group-association]
#   filename = "${var.project_name}-within-ws-rule.yaml"
#   content = templatefile("${path.module}/net-policy-template.yaml", {
#     project_name = var.project_name
#   })
# }
   
resource "rafay_project" "rafay_proj_new" {
  //depends_on = [ local_file.netpolicy-file ]
  metadata {
    name        = var.project_name
    description = "terraform project"
  }
  spec {
    default = false    
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
  add_users = ["${var.workspace_admins}"]
}

# resource "rafay_cluster_sharing" "demo-terraform-specific" {
#   depends_on = [rafay_project.rafay_proj_new]
#   clustername = var.cluster_name
#   project     = var.central_pool_name
#   sharing {
#     all = false
#     projects {
#       name = var.project_name
#     }    
#   }
# }

data "template_file" "example" {    
  depends_on = [ rafay_groupassociation.group-association ]
  template = file("${path.module}/net-policy-template.yaml")
  vars = {
      project_name = var.project_name
  }
}

resource "github_repository_file" "netfile" {
  depends_on = [data.template_file.example]
  repository     = "waas"
  branch         = "main"
  file           = "netfiles/${var.project_name}-within-ws-rule.yaml"
  content        = data.template_file.example.rendered
  overwrite_on_create = true
}

resource "rafay_namespace_network_policy_rule" "demo-withinworkspacerule" {
  depends_on = [github_repository_file.netfile]
  metadata {    
    name    = var.network_policy_rule_name
    project = var.project_name    
  }
  spec {
    artifact {
      type = "Yaml"
      artifact {               
        # repository = "waas-repo"
        # revision = "main"             

        paths {                               
          name = "${path.module}/netfiles/net-policy-template.yaml"       
          //name = "netfiles/${var.project_name}-within-ws-rule.yaml"          
          //name = "file://github.com/doremansunio/waas/tree/main/netfiles/${var.project_name}-within-ws-rule.yaml}}"
        } 
      }
    }
    version = "v1" //var.network_policy_rule_version
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
