# terraform-kubernetes-fluentd-cloudwatch

Terraform module which deploys Fluentd Cloud Watch Agent

[![TFLINT](https://github.com/bailey84j/terraform-kubernetes-fluentd-cloudwatch/actions/workflows/main.yml/badge.svg)](https://github.com/bailey84j/terraform-kubernetes-fluentd-cloudwatch/actions/workflows/main.yml)
[![LICENSE](https://img.shields.io/github/license/bailey84j/terraform-kubernetes-fluentd-cloudwatch)](https://github.com/bailey84j/terraform-kubernetes-fluentd-cloudwatch/blob/master/LICENSE)

---




## Examples

- [Standard](https://github.com/bailey84j/terraform-kubernetes-fluentd-cloudwatch/tree/master/examples/standard): Deploying Fluentd Cloudwatch Agent using the default settings
[![Deployment](https://github.com/bailey84j/terraform-kubernetes-fluentd-cloudwatch/actions/workflows/standard-deployment.yml/badge.svg)](https://github.com/bailey84j/terraform-kubernetes-fluentd-cloudwatch/actions/workflows/standard-deployment.yml)
- [Custom](https://github.com/bailey84j/terraform-kubernetes-fluentd-cloudwatch/tree/master/examples/custom): Customising the deployment to use a different name and namespace 

## Contributing

Report issues/questions/feature requests via [issues](https://github.com/bailey84j/terraform-kubernetes-fluentd-cloudwatch/issues/new)
Full contributing [guidelines are covered here](https://github.com/bailey84j/terraform-kubernetes-fluentd-cloudwatch/blob/master/.github/CONTRIBUTING.md)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.73.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.7.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [kubernetes_cluster_role.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_config_map.example](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_daemon_set_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/daemon_set_v1) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_service_account.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Determines whether a an IAM role is created or to use an existing IAM role for the cloudwatch agent | `bool` | `true` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Determines whether a an IAM role is created or to use an existing IAM role for the cloudwatch agent | `bool` | `false` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | The name of the target Kubernetes Cluster | `string` | n/a | yes |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | Existing IAM role ARN for the cloudwatch agent. Required if `create_iam_role` is set to `false` | `string` | `null` | no |
| <a name="input_iam_role_description"></a> [iam\_role\_description](#input\_iam\_role\_description) | Description of the role | `string` | `"Permissions required by the Kubernetes Fluentd to do it's job."` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Name to use on IAM role created | `string` | `null` | no |
| <a name="input_iam_role_path"></a> [iam\_role\_path](#input\_iam\_role\_path) | Cluster IAM role path | `string` | `"/eks/"` | no |
| <a name="input_iam_role_permissions_boundary"></a> [iam\_role\_permissions\_boundary](#input\_iam\_role\_permissions\_boundary) | ARN of the policy that is used to set the permissions boundary for the IAM role | `string` | `null` | no |
| <a name="input_iam_role_tags"></a> [iam\_role\_tags](#input\_iam\_role\_tags) | A map of additional tags to add to the IAM role created | `map(string)` | `{}` | no |
| <a name="input_iam_role_use_name_prefix"></a> [iam\_role\_use\_name\_prefix](#input\_iam\_role\_use\_name\_prefix) | Determines whether the IAM role name (`iam_role_name`) is used as a prefix | `string` | `true` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The name of the fluentd-cloudwatch container image | `string` | `"fluentd-kubernetes-daemonset"` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | The name of the fluentd-cloudwatch container image version | `string` | `"v1.14.3-debian-cloudwatch-1.0"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the fluentd deployment | `string` | `"fluentd"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to put the fluentd deployment in | `string` | `"kube-system"` | no |
| <a name="input_prefix_separator"></a> [prefix\_separator](#input\_prefix\_separator) | The separator to use between the prefix and the generated timestamp for resource names | `string` | `"-"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
