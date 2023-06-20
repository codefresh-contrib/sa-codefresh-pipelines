# Create EKS Cluster

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${var.eks_cluster_name}"
  cluster_version = "${var.eks_cluster_version}"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

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



# Create GitOps Runtime

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_endpoint]
      command     = "aws"
    }
  }
}

resource "helm_release" "gitops-runtime" {
  name       = "gitops-runtime"
  repository = "https://chartmuseum.codefresh.io/gitops-runtime"
  chart      = "gitops-runtime"

  values = [
    file("${path.module}/gitops-runtime-values.yaml")
  ]
}

# Generate generated-values.yaml for Runner

resource "docker_container" "codefresh" {
  name  = "codefresh"
  image = var.cf_cli_image
  env = ["CF_API_HOST=${var.cf_api_host}", "CF_API_TOKEN=${var.cf_api_token}"]
  volumes {
    host_path = "/codefresh/volume"
    container_path = "/codefresh/volume"
  }
  command = ["codefresh runner init", "--generate-helm-values-file"]
}

# Create Codefresh Runner

resource "helm_release" "cf_runtime" {
  name       = "cf-runtime"
  repository = "https://chartmuseum.codefresh.io/cf-runtime"
  chart      = "cf-runtime"

  values = [
    file("${path.module}/generated-values.yaml"),
    file("${path.module}/cf-runtime-values.yaml")
  ]
}
