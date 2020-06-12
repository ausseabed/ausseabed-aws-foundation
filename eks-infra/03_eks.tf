resource "aws_eks_cluster" "ga_sb_eks_cluster" {
  name     = "ga_sb_${var.env}_eks_cluster"
  role_arn = var.security.eks_role_arn

  vpc_config {
    subnet_ids = concat(var.networking.app_tier_subnets, var.networking.web_tier_subnets)
  }

  tags = {
    Name = "ga_sb_${var.env}_eks_cluster"
  }
}

resource "aws_iam_openid_connect_provider" "example" {
  client_id_list  = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = []
  url             = aws_eks_cluster.ga_sb_eks_cluster.identity.0.oidc.0.issuer
}

resource "aws_eks_fargate_profile" "ga_sb_eks_fargate_profile" {
  cluster_name           = aws_eks_cluster.ga_sb_eks_cluster.name
  fargate_profile_name   = "ga_sb_eks_${var.env}_fargate_profile"
  pod_execution_role_arn = var.security.eks_fargate_profile_arn
  subnet_ids             = var.networking.app_tier_subnets

  selector {
    namespace = "default"
  }

  selector {
    namespace = "kube-system"
  }


}

