data "terraform_remote_state" "vpc_remote" {
  backend = "s3"

  config = {
    bucket = "pvcb-state-s3"
    region = "ap-southeast-1"
    key    = "ciam-dev/ap-southeast-1/vpc/terraform.tfstate"
  }
}

data "aws_eks_cluster_auth" "this_cluster" {
  name = module.eks_cluster.cluster_name
}
