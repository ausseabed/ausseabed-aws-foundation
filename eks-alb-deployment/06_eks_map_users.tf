data "aws_region" "current" {}

data "aws_iam_role" "ga_sb_iam_eks_fargate_profile" {
  name = "ga_sb_${var.env}_eks_fargate_profile"
}

locals {
  k8s_cluster_name = "ga_sb_default_eks_cluster"

  map_fargate_role = {
    rolearn: data.aws_iam_role.ga_sb_iam_eks_fargate_profile.arn
    username: "system:node:{{SessionName}}"
    groups: [
      "system:bootstrappers",
      "system:nodes",
      "system:node-proxier"
    ]
  }
}

data "aws_eks_cluster" "ga" {
  name       = local.k8s_cluster_name
}

data "aws_eks_cluster_auth" "ga" {
  name = data.aws_eks_cluster.ga.name
}

