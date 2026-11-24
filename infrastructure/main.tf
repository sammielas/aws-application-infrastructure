resource "terraform_data" "backend_validation" {
  input = {
    environment = "dev"
    purpose     = "Remote state validation"
    managed_by  = "Terraform"
  }
}
