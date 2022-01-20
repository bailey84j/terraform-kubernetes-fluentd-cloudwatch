terraform {
  required_version = ">= 0.14.8"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}
