<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.aline_addr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip_association.eip_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip_association) | resource |
| [aws_instance.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [random_shuffle.subnets](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_eip"></a> [create\_eip](#input\_create\_eip) | whether or create an EIP for the ec2 instance or not | `bool` | `false` | no |
| <a name="input_infra_env"></a> [infra\_env](#input\_infra\_env) | infrastructure environment | `string` | n/a | yes |
| <a name="input_infra_role"></a> [infra\_role](#input\_infra\_role) | infrastructure purpose | `string` | n/a | yes |
| <a name="input_instance_ami"></a> [instance\_ami](#input\_instance\_ami) | Server image to use | `string` | n/a | yes |
| <a name="input_instance_root_device_size"></a> [instance\_root\_device\_size](#input\_instance\_root\_device\_size) | Root bock device size in GB | `number` | `20` | no |
| <a name="input_instance_size"></a> [instance\_size](#input\_instance\_size) | ec2 web server size | `string` | `"t3.medium"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | security groups to assign to server | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | valid subnets to assign to server | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Environment": "develop",<br>  "ManagedBy": "terraform",<br>  "Owner": "lynda",<br>  "Project": "lf-aline"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_eip"></a> [app\_eip](#output\_app\_eip) | n/a |
| <a name="output_app_instance"></a> [app\_instance](#output\_app\_instance) | n/a |
<!-- END_TF_DOCS -->