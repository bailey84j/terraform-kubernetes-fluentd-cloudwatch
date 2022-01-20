locals {
  # Your AWS EKS Cluster ID goes here.
  k8s_cluster_name = "my-k8s-cluster"
}

provider "aws" {
  region = "us-west-1"
}

data "aws_eks_cluster" "eks" {
  name = local.k8s_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = local.k8s_cluster_name

}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}


module "k8s_fluentd" {
  source = "../../"

  eks_cluster_name = local.k8s_cluster_name
}
