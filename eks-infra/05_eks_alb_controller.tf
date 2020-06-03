locals {
  # Your AWS EKS Cluster ID goes here.
  k8s_cluster_name = aws_eks_cluster.ga_sb_eks_cluster.name
}

data "aws_region" "current" {}

data "aws_eks_cluster" "target" {
  name       = local.k8s_cluster_name
  depends_on = [
    aws_eks_cluster.ga_sb_eks_cluster]
}

data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.aws_eks_cluster.target.name
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.target.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  load_config_file       = false
}

//
//module "alb_ingress_controller" {
//  source                            = "iplabs/alb-ingress-controller/kubernetes"
//  version                           = "3.1.0"
//
//  providers = {
//    kubernetes = "kubernetes.eks"
//  }
//
//  k8s_cluster_type = "eks"
//  k8s_namespace    = "kube-system"
//
//  aws_region_name  = data.aws_region.current.name
//  k8s_cluster_name = aws_eks_cluster.ga_sb_eks_cluster.name
//}