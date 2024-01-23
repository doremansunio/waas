terraform {
  required_providers {
    rafay = {
      source = "RafaySystems/rafay"
      version = "1.1.22"
    }
  }
}

provider "rafay" {
  provider_config_file = "./rafay_config.json"
}

resource "null_resource" "tfc_test" {
  count = 10
  provisioner "local-exec" {
    command = "echo 'Test ${count.index}'"
  }
}
   
resource "rafay_project" "tfdemoproject1" {
  metadata {
    name        = "tfdemoproject1"
    description = "terraform project"
  }
  spec {
    default = false
  }
}
