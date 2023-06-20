#### AWS Configuration

variable "aws_region" {
  type = string
  default = "us-east-1"
  description = "Region for EKS cluster"
}

variable "aws_role_arn" {
  type = string
  default = ""
  description = "ARN for AWS Role to assume to run Terraform against Amazon"
}
# Requires you configure a service account for Codefresh Runner
# Documentation: https://codefresh.io/docs/docs/installation/codefresh-runner/#injecting-aws-arn-roles-into-the-cluster

#### EKS Configuration

variable "eks_cluster_name" {
  type = string
  default = "terraform-demo"
  description = "Name for EKS cluster"
}

variable "eks_cluster_version" {
  type = string
  default = "1.27"
  description = "EKS Cluster Version"
}
# Documentation: https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html

variable "eks_vpc_id" {
  type = string
  default = ""
  description = "VPC for EKS cluster"
}

variable "eks_subnet_ids" {
  type = list
  description = "Subnets for EKS cluster workers"
}

variable "eks_control_plane_subnet_ids" {
  type = list
  description = "Subnet IDs for EKS cluster control plane"
}

variable "eks_mng_instance_types" {
  type = list
  default = ["t3.large"]
  description = "Instance types for EKS Managed Node Group"
}

variable "eks_mng_min_size" {
  type = number
  default = 1
  description = "Minimum EKS Managed Node Group size"
}

variable "eks_mng_max_size" {
  type = number
  default = 2
  description = "Maximum EKS Managed Node Group size"
}

variable "eks_mng_desired_size" {
  type = number
  default = 1
  description = "Desired EKS Managed Node Group size"
}

variable "eks_mng_capacity_type" {
  type = string
  default = "SPOT"
  description = "EKS Managed Node Group CapacityType"
}
# Documentation: https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html

variable "eks_mng_tags" {
  type = map
  default = {environment = "dev", Terraform = "true"}
  description = "EKS Managed Node Group CapacityType"
}

#### Codefresh Configuration

variable "cf_api_host" {
  type = string
  default = "http://g.codefresh.io/api"
  description = "Codefresh URL access. SAAS is at http://g.codefresh.io/api"
}
# Only required to be changed for self hosted control plane.

variable "cf_api_token" {
  type    = string
  default = ""
  sensitive = true
  description = "Codefresh access token. Create it from the Codefresh UI"
}
# Documentation: https://codefresh.io/docs/docs/integrations/codefresh-api/#authentication-instructions

variable "cf_cli_image" {
  type = string
  default = "quay.io/codefresh/cli"
  description = "Codefresh CLI Docker image"
}
# Documentation: https://quay.io/repository/codefresh/cli

#Unused

variable "cf_volume" {
  type = string
  default = "/codefresh/volume"
  description = "Codefresh Volume Mount Path"
}
# Documentation: https://codefresh.io/docs/docs/pipelines/introduction-to-codefresh-pipelines/#sharing-the-workspace-between-build-steps

variable "cf_container_volume_mount" {
  type = string
  default = "/codefres/volume"
  description = "Codefresh CLI Container Volume Mount Path"
}