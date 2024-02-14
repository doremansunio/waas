terraform {
  required_providers {
    rafay = {
      source = "RafaySystems/rafay"
      version = "1.1.22"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "rafay" {
  # provider_config_file = "./rafay_config.json"
}

provider "aws" {
    region = "ap-south-1"
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

resource "aws_s3_object" "s3file" {
  depends_on = [ data.template_file.example ]
  bucket = "rafay-s3-bucket" //data.aws_s3_bucket.bukname.bucket
  key = "my-folder/${var.project_name}-within-ws-rule.yaml"
  content = data.template_file.example.rendered     
}


resource "rafay_namespace_network_policy_rule" "demo-withinworkspacerule" {
  depends_on = [aws_s3_object.s3file]
  metadata {    
    name    = var.network_policy_rule_name
    project = var.project_name
  }
  spec {
    artifact {
      type = "Yaml"
      artifact { 
        paths {           
          //name = "file://${var.project_name}-within-ws-rule.yaml"
          name = "file://${aws_s3_object.s3file.key}"
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
