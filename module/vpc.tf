module "dead-simple-auth-vpc" {
  source = "terraform-aws-modules/vpc/aws"
  count  = var.create_vpc == true ? 1 : 0

  name            = "dead-simple-auth-vpc"
  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  cidr            = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}