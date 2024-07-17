output "configure_kubectl" {
  value = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks_cluster.cluster_name}"
}
