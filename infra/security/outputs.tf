#-----networking/outputs.tf

output "eks_role_arn" {
  value = aws_iam_role.ga_sb_eks_role.arn
}

output "eks_fargate_profile_arn" {
  value = aws_iam_role.ga_sb_iam_eks_fargate_profile.arn
}
