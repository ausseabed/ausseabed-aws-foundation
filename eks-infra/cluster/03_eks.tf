data "aws_iam_role" "ga_sb_eks_role" {
  name = "ga_sb_${var.env}_eks_role"
}

data "aws_iam_role" "ga_sb_iam_eks_fargate_profile" {
  name = "ga_sb_${var.env}_eks_fargate_profile"
}

resource "aws_eks_cluster" "ga_sb_eks_cluster" {
  name     = "ga_sb_${var.env}_eks_cluster"
  role_arn = data.aws_iam_role.ga_sb_eks_role.arn

  version = "1.18"
  enabled_cluster_log_types = ["api", "authenticator", "controllerManager", "scheduler"]
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
  thumbprint_list = ["33db8f260b90759d648f549e5f8ed56be2f1ad25"] #https://github.com/terraform-providers/terraform-provider-aws/issues/10104
  url             = aws_eks_cluster.ga_sb_eks_cluster.identity.0.oidc.0.issuer
}

resource "aws_eks_fargate_profile" "ga_sb_eks_fargate_profile" {
  fargate_profile_name   = "ga_sb_eks_${var.env}_fargate_profile"
  cluster_name           = aws_eks_cluster.ga_sb_eks_cluster.name
  pod_execution_role_arn = data.aws_iam_role.ga_sb_iam_eks_fargate_profile.arn
  subnet_ids             = var.networking.app_tier_subnets

  selector {
    namespace = "default"
  }

  selector {
    namespace = "kube-system"
  }

}

