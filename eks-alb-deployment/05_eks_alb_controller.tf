data "aws_region" "current" {}

locals {
  # Your AWS EKS Cluster ID goes here.
  k8s_cluster_name = "ga_sb_default_eks_cluster"
}

data "aws_eks_cluster" "ga" {
  name       = local.k8s_cluster_name
//  depends_on = [
//    aws_eks_cluster.ga_sb_eks_cluster,
//    aws_eks_fargate_profile.ga_sb_eks_fargate_profile]
}

data "aws_eks_cluster_auth" "ga" {
  name = data.aws_eks_cluster.ga.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.ga.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.ga.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.ga.token
  load_config_file       = false
}



module "alb_ingress_controller" {
  source                            = "iplabs/alb-ingress-controller/kubernetes"
  version                           = "3.1.0"


  k8s_cluster_type = "eks"
  k8s_namespace    = "kube-system"

  aws_region_name  = data.aws_region.current.name
  k8s_cluster_name = data.aws_eks_cluster.ga.name
}

