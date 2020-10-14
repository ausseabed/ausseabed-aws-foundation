data "aws_eks_cluster" "ga" {
  name = "ga_sb_${local.env}_eks_cluster"
}

data "aws_eks_cluster_auth" "ga" {
  name = "ga_sb_${local.env}_eks_cluster"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.ga.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.ga.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.ga.token
  load_config_file       = false
}

provider "helm" {
}

data "kubernetes_ingress" "example" {
  metadata {
    name = "spt-ingress"
  }
  depends_on = [helm_release.survey-planning-tool]
}

resource "helm_release" "survey-planning-tool" {
  depends_on = [
    module.postgres
  ]
  name       = "survey-planning-tool"
  repository = "./helm"
  chart      = "survey-planning-tool"
  timeout    = 1000
  wait       = true

  set_sensitive {
    name  = "secrets.postgres_password"
    value = module.postgres.db_password
  }

  set_sensitive {
    name  = "secrets.auth_client_id"
    value = aws_cognito_user_pool_client.client.id
  }

  set_sensitive {
    name  = "secrets.auth_client_secret"
    value = aws_cognito_user_pool_client.client.client_secret
  }

  set_sensitive {
    name  = "secrets.postgres_user"
    value = module.postgres.db_user
  }

  set_sensitive {
    name  = "secrets.postgres_password"
    value = module.postgres.db_password
  }

  set {
    type = "string"
    name  = "ingress.certificate_arn"
    value = aws_acm_certificate.spt_cert.arn
  }

  set {
    type = "string"
    name  = "cognito.host"
    value = "https://${aws_cognito_user_pool_domain.main.domain}.auth.ap-southeast-2.amazoncognito.com"
  }

  set {
    type = "string"
    name  = "database.host"
    value = module.postgres.db_host
  }

  set {
    type = "string"
    name  = "database.port"
    value = module.postgres.db_port
  }

  set {
    type = "string"
    name  = "database.name"
    value = module.postgres.db_name
  }


}