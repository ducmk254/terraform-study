provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this_cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this_cluster.token
  }
}


#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.12"

  cluster_name                   = "${local.projectName}-${local.environment}-cluster"
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true # NON-PRODUCTION

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  vpc_id                   = data.terraform_remote_state.vpc_remote.outputs.vpc_id
  subnet_ids               = slice(data.terraform_remote_state.vpc_remote.outputs.private_subnets[*], 0, 3)
  control_plane_subnet_ids = slice(data.terraform_remote_state.vpc_remote.outputs.private_subnets[*], 3, 6)

  create_cloudwatch_log_group = false

  eks_managed_node_groups = {
    initial = {
      force_update_version = true

      instance_types = ["t2.medium"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1
    }

    # initial-1-24-spot = {
    #   name                 = "infinity-dev-nodespot"
    #   description          = "EKS node group Infinity-dev-eks-1-24-spot"
    #   force_update_version = true
    #   capacity_type        = "SPOT"
    #   instance_types       = ["m5.large", "m5.xlarge"]
    #   # ami_id         = data.aws_ami.eks_1_24.image_id
    #   min_size     = 3
    #   max_size     = 10
    #   desired_size = 10
    #   #remote_access = {
    #   #  ec2_ssh_key               = "infinity-eks-node-key"
    #   #}
    #   labels = {
    #     "pvcombank.io/eks"      = "1.24"
    #     "pvcombank.io/eks"      = "1.24"
    #     "pvcombank.io/eks-type" = "spot"
    #   }
    # }
    ##infinispan = {
    ##  instance_types = ["m5.large"]
    ##  subnet_ids     = ["subnet-094fa391c3f17ca4b"]
    ##  min_size       = 4
    ##  max_size       = 4
    ##  desired_size   = 4
    ##  labels = {
    ##    "pvcombank.io/apps" = "infinispan"
    ##  }
    ##  taints = {
    ##    dedicated = {
    ##      key    = "pvcombank.io/apps"
    ##      value  = "infinispan"
    ##      effect = "NO_SCHEDULE"
    ##    }
    ##  }
    ##}

    ##keycloak = {
    ##  instance_types = ["m5.large"]
    ##  subnet_ids     = ["subnet-094fa391c3f17ca4b"]
    ##  min_size       = 3
    ##  max_size       = 3
    ##  desired_size   = 3
    ##  labels = {
    ##    "pvcombank.io/apps" = "keycloak"
    ##  }
    ##  taints = {
    ##    dedicated = {
    ##      key    = "pvcombank.io/apps"
    ##      value  = "keycloak"
    ##      effect = "NO_SCHEDULE"
    ##    }
    ##  }
    ##}
  }

  manage_aws_auth_configmap = true
  aws_auth_roles            = local.aws_auth

  tags = local.tags
}

module "eks_blueprints_kubernetes_addons" {
  source               = "git::https://github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"
  eks_cluster_id       = module.eks_cluster.cluster_name
  eks_cluster_endpoint = module.eks_cluster.cluster_endpoint
  eks_oidc_provider    = module.eks_cluster.oidc_provider
  eks_cluster_version  = module.eks_cluster.cluster_version

  enable_ingress_nginx = true

  ingress_nginx_helm_config = {
    repository = "https://kubernetes.github.io/ingress-nginx"
    version    = "4.5.2"
    # values     = [templatefile("${path.module}/helm-values/ingress-nginx-values.yaml", {})]
  }

  enable_argocd         = true #true
  argocd_manage_add_ons = false
  argocd_helm_config = {
    version = "5.42.3"
    values  = [templatefile("${path.module}/helm-values/argocd-values.yaml", {})]
  }

  enable_cert_manager = true
  cert_manager_helm_config = {
    version = "1.13.1"
    values  = [templatefile("${path.module}/helm-values/cert-manager-values.yaml", {})]

  }
  #cert_manager_domain_names = var.apps_domain

  enable_karpenter = true
  enable_cilium    = true

  enable_amazon_eks_kube_proxy          = false
  enable_amazon_eks_aws_ebs_csi_driver  = false #true
  enable_aws_for_fluentbit              = false
  aws_for_fluentbit_create_cw_log_group = false
  enable_aws_load_balancer_controller   = false #true
  enable_metrics_server                 = false #true
  enable_prometheus                     = false

  tags = local.tags
}

module "eg_eks_bastion_label" {
  source = "cloudposse/label/null"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace = "ducmk254"
  tenant    = "ciam"
  stage     = "dev"
  name      = "eks_cluster"
  delimiter = "-"

  tags = {
    DeployBy  = "ChuanKv"
    ManagedBy = "Terraform"
  }
}
