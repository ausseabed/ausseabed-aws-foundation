data "aws_eks_cluster" "ga" {
  name = "ga_sb_${local.env}_eks_cluster"
}

data "aws_eks_cluster_auth" "ga" {
  name = "ga_sb_${local.env}_eks_cluster"
}

provider "helm" {
  kubernetes {
    host = data.aws_eks_cluster.ga.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.ga.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.ga.token
    load_config_file       = false
  }
}

resource "helm_release" "helm_hello" {
  name       = "ubuntu-debug"
  repository = "./helm"
  chart      = "helloworld"
  timeout = 1000

  set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

}