resource "terraform_data" "backend_validation" {
  input = {
    environment = "dev"
    purpose     = "Remote state validation"
    managed_by  = "Terraform"
  }
}

module "networking" {
  source = "./modules/networking"

  name     = "application-dev"
  vpc_cidr = "10.20.0.0/16"

  subnets = {
    public-a = {
      cidr_block        = "10.20.1.0/24"
      availability_zone = "us-east-1a"
      public            = true
    }
    public-b = {
      cidr_block        = "10.20.2.0/24"
      availability_zone = "us-east-1b"
      public            = true
    }
    private-a = {
      cidr_block        = "10.20.11.0/24"
      availability_zone = "us-east-1a"
      public            = false
    }
    private-b = {
      cidr_block        = "10.20.12.0/24"
      availability_zone = "us-east-1b"
      public            = false
    }
  }

  tags = {
    Environment = "dev"
    Project     = "application-infrastructure"
    ManagedBy   = "Terraform"
  }
}
