provider "rafay" { } 
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