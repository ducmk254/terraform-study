locals {
  projectName = "ciam"
  environment = "dev"
  azs         = slice(data.aws_availability_zones.available.names, 0, 3)
  region      = "ap-southeast-1"
  tags = {
    DeployBy  = "ChuanKv"
    ManagedBy = "Terraform"
  }
}

data "aws_availability_zones" "available" {

}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>4.0"

  name = "${local.projectName}-${local.environment}-vpc"
  cidr = "10.212.128.0/20"

  azs = local.azs

  public_subnets       = ["10.212.128.0/24", "10.212.129.0/24", "10.212.130.0/24"]
  private_subnets      = ["10.212.131.0/24", "10.212.132.0/24", "10.212.133.0/24", "10.212.134.0/24", "10.212.135.0/24", "10.212.136.0/24"]
  public_subnet_names  = ["${local.projectName}-${local.environment}-public-1a", "${local.projectName}-${local.environment}-public-1b", "${local.projectName}-${local.environment}-public-1c"]
  private_subnet_names = ["${local.projectName}-${local.environment}-private-1a", "${local.projectName}-${local.environment}-private-1b", "${local.projectName}-${local.environment}-private-1c"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/role/elb"                 = 1
    "kubernetes.io/cluster/ciam-dev-cluster" = "owned" #nên đặt sau cluster là tên thực tế của cluster
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"        = 1
    "kubernetes.io/cluster/ciam-dev-cluster" = "owned" #nên đặt sau cluster là tên thực tế của cluster

  }


}
