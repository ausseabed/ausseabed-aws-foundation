data "aws_region" "current" {}

locals {
  # Your AWS EKS Cluster ID goes here.
  k8s_cluster_name = aws_eks_cluster.ga_sb_eks_cluster.name
  cicd_service_account_map    = map(
  "default", "circleci",
  "prod", "ga_aws_prd_sb_svc_cicd"
  )

  cicd_service_account=local.cicd_service_account_map[var.env]

}

data "aws_eks_cluster" "ga" {
  name       = local.k8s_cluster_name
  depends_on = [
    aws_eks_cluster.ga_sb_eks_cluster,
    aws_eks_fargate_profile.ga_sb_eks_fargate_profile]
}

data "aws_eks_cluster_auth" "ga" {
  name = data.aws_eks_cluster.ga.name
}

data "aws_iam_user" "cicd_service_account" {
  user_name = local.cicd_service_account
}

data "template_file" "aws_auth" {
  template = <<EOF
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      - system:node-proxier
      rolearn: ${data.aws_iam_role.ga_sb_iam_eks_fargate_profile.arn}
      username: system:node:{{SessionName}}
  mapUsers: |
    - groups:
      - system:masters
      userarn: ${data.aws_iam_user.cicd_service_account.arn}
      username: circleci
kind: ConfigMap
metadata:
  creationTimestamp: "2020-08-03T07:44:09Z"
  name: aws-auth
  namespace: kube-system
  selfLink: /api/v1/namespaces/kube-system/configmaps/aws-auth

EOF
}

data "template_file" "kubeconfig" {
  depends_on = [
    aws_eks_fargate_profile.ga_sb_eks_fargate_profile,
    aws_eks_cluster.ga_sb_eks_cluster
  ]

  template = <<EOF
apiVersion: v1
kind: Config
current-context: terraform
clusters:
- name: main
  cluster:
    certificate-authority-data: ${aws_eks_cluster.ga_sb_eks_cluster.certificate_authority.0.data}
    server: ${aws_eks_cluster.ga_sb_eks_cluster.endpoint}
contexts:
- name: terraform
  context:
    cluster: main
    user: terraform
users:
- name: terraform
  user:
    token: ${data.aws_eks_cluster_auth.ga.token}
EOF
}

resource "null_resource" "coredns_patch" {
  depends_on = [
    aws_eks_fargate_profile.ga_sb_eks_fargate_profile
  ]

  triggers = {
    fargate_profile = aws_eks_fargate_profile.ga_sb_eks_fargate_profile.arn
  }

  provisioner "local-exec" {
    interpreter = [
      "/bin/bash",
      "-c"
    ]
    command     = <<EOF
  kubectl --kubeconfig=<(echo '${data.template_file.kubeconfig.rendered}') \
   patch deployment coredns \
   --namespace kube-system \
   --type=json \
   -p='[{"op": "remove", "path": "/spec/template/metadata/annotations", "value": "eks.amazonaws.com/compute-type"}]'

  kubectl --kubeconfig=<(echo '${data.template_file.kubeconfig.rendered}') \
   rollout restart deployments/coredns \
   --namespace kube-system

EOF
  }
}


resource "null_resource" "configmap_update" {
  depends_on = [
    aws_eks_fargate_profile.ga_sb_eks_fargate_profile
  ]

  triggers = {
    fargate_profile = aws_eks_fargate_profile.ga_sb_eks_fargate_profile.arn
  }

  provisioner "local-exec" {
    interpreter = [
      "/bin/bash",
      "-c"
    ]
    command     = <<EOF

  kubectl --kubeconfig=<(echo '${data.template_file.kubeconfig.rendered}') \
   apply -f <(echo '${data.template_file.aws_auth.rendered}') \
   --namespace kube-system

EOF
  }
}