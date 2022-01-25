# AWS Fluentd Agent Deployment in Kubernetes Cluster

Deploy AWS Fluentd Agent Deployment in Kubernetes Cluster using the standard settings

[![Terraform](https://img.shields.io/badge/tf->%3D0.14.8-blue.svg)](https://www.terraform.io/downloads)


## Usage

To run this example you need to execute:

```bash

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""

export TF_VAR_k8s_cluster_name="Test"

$ terraform init
$ terraform plan
$ terraform apply
```
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
