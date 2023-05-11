# Terraform DigitalOcean module for Instellar

This module automatically forms LXD cluster on DigitalOcean. This terraform module will do the following:

- [x] Setup networking
- [x] Setup bastion node
- [x] Setup compute instances
- [x] Setup Private Key access
- [x] Automatically form a cluster
- [x] Destroy a cluster
- [x] Enable removal of specific nodes gracefully
- [x] Protect against `database-leader` deletion

These functionality come together to enable the user to fully manage LXD cluster using IaC (infrastructure as code)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.28.1 |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 2.6.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.bastion](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_droplet.bootstrap_node](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_droplet.nodes](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_firewall.bastion_firewall](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [digitalocean_firewall.nodes_firewall](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [digitalocean_project.project](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/project) | resource |
| [digitalocean_ssh_key.bastion](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/ssh_key) | resource |
| [digitalocean_ssh_key.terraform_cloud](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/ssh_key) | resource |
| [digitalocean_tag.db_access](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/tag) | resource |
| [digitalocean_tag.instellar_bastion](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/tag) | resource |
| [digitalocean_tag.instellar_node](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/tag) | resource |
| [digitalocean_vpc.cluster_vpc](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/vpc) | resource |
| [ssh_resource.cluster_join_token](https://registry.terraform.io/providers/loafoe/ssh/latest/docs/resources/resource) | resource |
| [ssh_resource.node_detail](https://registry.terraform.io/providers/loafoe/ssh/latest/docs/resources/resource) | resource |
| [ssh_resource.trust_token](https://registry.terraform.io/providers/loafoe/ssh/latest/docs/resources/resource) | resource |
| [terraform_data.reboot](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [terraform_data.removal](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [tls_private_key.bastion_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/resources/private_key) | resource |
| [tls_private_key.terraform_cloud](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_size"></a> [bastion\_size](#input\_bastion\_size) | Size of the bastion instance defaults to Basic 512MB instance https://slugs.do-api.dev/ | `string` | `"s-1vcpu-512mb-10gb"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name for your cluster | `any` | n/a | yes |
| <a name="input_cluster_topology"></a> [cluster\_topology](#input\_cluster\_topology) | How many nodes do you want in your cluster? | <pre>list(object({<br>    id   = number<br>    name = string<br>    size = optional(string, "s-1vcpu-1gb")<br>  }))</pre> | `[]` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | Digital Ocean API Token | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for project in Digital Ocean possible values are Development, Staging, Production | `string` | `"Production"` | no |
| <a name="input_image"></a> [image](#input\_image) | Image type of choice default is ubuntu 22.04 x86 | `string` | `"ubuntu-22-04-x64"` | no |
| <a name="input_node_size"></a> [node\_size](#input\_node\_size) | Size of instances you want to use defaults to Basic 1GB instances https://slugs.do-api.dev/ | `string` | `"s-1vcpu-1gb"` | no |
| <a name="input_protect_leader"></a> [protect\_leader](#input\_protect\_leader) | Protect database leader node | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for your cluster | `string` | `"sgp1"` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | List of ssh keys fingerprint | `list(string)` | `[]` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Storage size to use with cluster | `any` | n/a | yes |
| <a name="input_vpc_ip_range"></a> [vpc\_ip\_range](#input\_vpc\_ip\_range) | The IP range to use for VPC | `string` | `"10.0.1.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_address"></a> [cluster\_address](#output\_cluster\_address) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_cluster_vpc_id"></a> [cluster\_vpc\_id](#output\_cluster\_vpc\_id) | n/a |
| <a name="output_db_access_tag_id"></a> [db\_access\_tag\_id](#output\_db\_access\_tag\_id) | n/a |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_trust_token"></a> [trust\_token](#output\_trust\_token) | n/a |
<!-- END_TF_DOCS -->