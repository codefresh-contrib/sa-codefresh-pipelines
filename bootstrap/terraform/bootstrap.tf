# Create EKS Cluster

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${var.eks_cluster_name}"
  cluster_version = "${var.eks_cluster_version}"
  cluster_encryption_config = {}

  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0"
  ]

  vpc_id                   = "${var.eks_vpc_id}"
  subnet_ids               = var.eks_subnet_ids
  control_plane_subnet_ids = var.eks_control_plane_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    node_group = {
      min_size     = var.eks_mng_min_size
      max_size     = var.eks_mng_max_size
      desired_size = var.eks_mng_desired_size

      instance_types = var.eks_mng_instance_types
      capacity_type  = "${var.eks_mng_capacity_type}"
    }
  }

  tags = var.eks_mng_tags
}

# Create KubeConfig

data "aws_eks_cluster_auth" current {
  name = module.eks.cluster_name
}

locals {
  kubeconfig = <<-EOT
    apiVersion: v1
    clusters:
    - cluster:
        server: ${module.eks.cluster_endpoint}
        certificate-authority-data: ${module.eks.cluster_certificate_authority_data}
      name: ${module.eks.cluster_name}
    contexts:
    - context:
        cluster: ${module.eks.cluster_name}
        user: ${module.eks.cluster_name}
      name: ${module.eks.cluster_name}
    current-context: ${module.eks.cluster_name}
    kind: Config
    preferences: {}
    users:
    - name: ${module.eks.cluster_name}
      user:
        token: ${nonsensitive(data.aws_eks_cluster_auth.current.token)}
  EOT
}

resource "local_file" "temp_config" {
  filename  = var.kubeconfig_name
  content   = local.kubeconfig
}

# Create GitOps Runtime

resource "helm_release" "gitops-runtime" {
  name       = "gitops-runtime"
  repository = "https://chartmuseum.codefresh.io/gitops-runtime"
  chart      = "gitops-runtime"
  devel      = "true"
  namespace  = "codefresh"
  create_namespace = "true"

  values = [
    file("${path.module}/gitops-runtime-values.yaml")
  ]

  set {
    name  = "global.codefresh.accountId"
    value = var.cf_account_id
  }

  set {
    name  = "global.codefresh.userToken.token"
    value = var.cf_api_token
  }

  set {
    name  = "global.runtime.name"
    value = module.eks.cluster_name
  }
  depends_on = [
    module.eks
  ]
}

# Generate generated-values.yaml for Runner

resource "docker_container" "codefresh" {
  name  = "codefresh"
  image = var.cf_cli_image
  env = ["CF_API_HOST=${var.cf_api_host}", "CF_API_KEY=${var.cf_api_token}", "KUBECONFIG=/codefresh/volume/${var.kubeconfig_name}", "CF_ARG_KUBE_NAMESPACE=${var.cf_runtime_namespace}"]
  volumes {
    host_path = "/Users/dustinvanbuskirk/src/codefresh-contrib/sa-codefresh-pipelines/bootstrap/terraform"
    container_path = "/codefresh/volume"
  }
  working_dir = "/codefresh/volume"
  command = ["runner", "init", "--generate-helm-values-file", "--yes"]
  attach = "true"
  must_run = "false"
}

# Create Codefresh Runtime

resource "helm_release" "cf_runtime" {
  name       = "cf-runtime"
  repository = "https://chartmuseum.codefresh.io/cf-runtime"
  chart      = "cf-runtime"
  namespace  = "codefresh"
  create_namespace = "true"

  values = [
    file("${path.module}/generated_values.yaml"),
    file("${path.module}/cf-runtime-values.yaml")
  ]

  set {
    name  = "global.runtimeNname"
    value = module.eks.cluster_name
  }
  depends_on = [
    docker_container.codefresh
  ]
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      values,
    ]
  }
}