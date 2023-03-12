<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 19.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | type of ami for ec2 nodes | `string` | `"BOTTLEROCKET_x86_64"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | name of cluster | `string` | `""` | no |
| <a name="input_cluster_subnet_ids"></a> [cluster\_subnet\_ids](#input\_cluster\_subnet\_ids) | list of cluster subnet ids | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | version number of cluster | `string` | `"1.24"` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | list of instance types | `list(string)` | <pre>[<br>  "t3.medium"<br>]</pre> | no |
| <a name="input_private_ng_desired_size"></a> [private\_ng\_desired\_size](#input\_private\_ng\_desired\_size) | desired count for private ng | `number` | `2` | no |
| <a name="input_private_ng_max_size"></a> [private\_ng\_max\_size](#input\_private\_ng\_max\_size) | max count for private ng | `number` | `4` | no |
| <a name="input_private_ng_min_size"></a> [private\_ng\_min\_size](#input\_private\_ng\_min\_size) | min count for private ng | `number` | `2` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | private subnets | `any` | `""` | no |
| <a name="input_public_ng_desired_size"></a> [public\_ng\_desired\_size](#input\_public\_ng\_desired\_size) | desired count for public ng | `number` | `2` | no |
| <a name="input_public_ng_max_size"></a> [public\_ng\_max\_size](#input\_public\_ng\_max\_size) | max count for public ng | `number` | `4` | no |
| <a name="input_public_ng_min_size"></a> [public\_ng\_min\_size](#input\_public\_ng\_min\_size) | min count for public ng | `number` | `2` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | public subnets | `any` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Environment": "develop",<br>  "ManagedBy": "terraform",<br>  "Owner": "lynda",<br>  "Project": "lf-aline"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | cluster vpc | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->