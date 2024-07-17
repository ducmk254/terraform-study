locals {
  projectName     = "ciam"
  environment     = "dev"
  region          = "ap-southeast-1"
  cluster_version = "1.29"

  aws_auth = yamldecode(file("auths/data.yaml"))

  tags = {
    DeployBy  = "ChuanKv"
    ManagedBy = "Terraform"
  }
}
