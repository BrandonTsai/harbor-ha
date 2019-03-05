module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "darumatic-harbor"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.200.0/23", "10.0.202.0/23"]
  public_subnets  = ["10.0.210.0/24", "10.0.211.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  default_vpc_tags = {
    Terraform   = "true"
    Environment = "production"
  }

  private_subnet_tags = {
    Terraform   = "true"
    Environment = "production"
    SubnetType  = "Private"
  }

  public_subnet_tags = {
    Terraform   = "true"
    Environment = "production"
    SubnetType  = "Public"
  }
}
