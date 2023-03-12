<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_security_group.rds_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.mysql_inbound_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aline_db_subnet_group_name"></a> [aline\_db\_subnet\_group\_name](#input\_aline\_db\_subnet\_group\_name) | db subnet group name | `string` | n/a | yes |
| <a name="input_db_allocated_storage"></a> [db\_allocated\_storage](#input\_db\_allocated\_storage) | allocated storage in GiB | `number` | `10` | no |
| <a name="input_db_engine"></a> [db\_engine](#input\_db\_engine) | engine for MySQL RDS | `string` | `"mysql"` | no |
| <a name="input_db_engine_version"></a> [db\_engine\_version](#input\_db\_engine\_version) | engine for MySQL RDS | `string` | `"8.0.28"` | no |
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | RDS instance type and size | `string` | `"db.t3.micro"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | default name for database | `string` | `"alinedb"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | The master password of the mysql cluster | `string` | `"really_good_password"` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | The master username of the mysql cluster | `string` | n/a | yes |
| <a name="input_infra_env"></a> [infra\_env](#input\_infra\_env) | The infrastructure environment. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | <pre>{<br>  "Environment": "develop",<br>  "ManagedBy": "terraform",<br>  "Owner": "lynda",<br>  "Project": "lf-aline"<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->