terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  assume_role {
    role_arn = var.aws_role_arn
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
