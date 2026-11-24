terraform {
  required_version = "= 1.16.0"

  backend "s3" {
    bucket       = "application-infrastructure-state"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

    endpoints = {
      s3 = "http://127.0.0.1:4567"
    }

    use_path_style              = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
  }
}
