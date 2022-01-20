# region AWS Data Resources
data "aws_region" "current" {}

# region EKS Data Resources
data "aws_eks_cluster" "target" {
  name = var.eks_cluster_name
}

data "aws_partition" "current" {}


data "aws_caller_identity" "current" {}
