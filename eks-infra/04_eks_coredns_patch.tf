data "aws_eks_cluster_auth" "ga" {
  name = "ga_sb_${var.env}_eks_cluster"
}

data "template_file" "kubeconfig" {
  depends_on = [
    aws_eks_fargate_profile.ga_sb_eks_fargate_profile
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
EOF
  }
}