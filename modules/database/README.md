<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | ~> 2.31 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_database_cluster.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_cluster) | resource |
| [digitalocean_database_firewall.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_firewall) | resource |
| [digitalocean_project_resources.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/project_resources) | resource |
| [digitalocean_database_ca.this](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/database_ca) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_access_tags"></a> [db\_access\_tags](#input\_db\_access\_tags) | Tags of nodes that have db access | `list(string)` | n/a | yes |
| <a name="input_db_node_count"></a> [db\_node\_count](#input\_db\_node\_count) | Node count for the database | `number` | `1` | no |
| <a name="input_db_size"></a> [db\_size](#input\_db\_size) | Size of your cluster see https://docs.digitalocean.com/reference/api/api-reference/#operation/registry_get_options | `string` | `"db-s-1vcpu-1gb"` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Define the database engine to use | `string` | `"pg"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | PostgreSQL version | `string` | `"13"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Name of your cluster | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project id to assign the database to | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for your cluster | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | n/a |
| <a name="output_certificate"></a> [certificate](#output\_certificate) | n/a |
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | n/a |
| <a name="output_engine_version"></a> [engine\_version](#output\_engine\_version) | n/a |
| <a name="output_identifier"></a> [identifier](#output\_identifier) | n/a |
| <a name="output_password"></a> [password](#output\_password) | n/a |
| <a name="output_port"></a> [port](#output\_port) | n/a |
| <a name="output_username"></a> [username](#output\_username) | n/a |
<!-- END_TF_DOCS -->