<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.31 |
| <a name="requirement_instellar"></a> [instellar](#requirement\_instellar) | ~> 0.6 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket"></a> [bucket](#module\_bucket) | ../../modules/storage | n/a |
| <a name="module_compute_primary"></a> [compute\_primary](#module\_compute\_primary) | ../.. | n/a |
| <a name="module_database_primary"></a> [database\_primary](#module\_database\_primary) | ../../modules/database | n/a |
| <a name="module_networking_primary"></a> [networking\_primary](#module\_networking\_primary) | ../../modules/network | n/a |
| <a name="module_postgresql_service"></a> [postgresql\_service](#module\_postgresql\_service) | upmaru/bootstrap/instellar//modules/service | ~> 0.5 |
| <a name="module_primary_cluster"></a> [primary\_cluster](#module\_primary\_cluster) | upmaru/bootstrap/instellar | ~> 0.5 |
| <a name="module_storage"></a> [storage](#module\_storage) | upmaru/bootstrap/instellar//modules/storage | ~> 0.5 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_do_access_key"></a> [do\_access\_key](#input\_do\_access\_key) | n/a | `any` | n/a | yes |
| <a name="input_do_region"></a> [do\_region](#input\_do\_region) | n/a | `any` | n/a | yes |
| <a name="input_do_secret_key"></a> [do\_secret\_key](#input\_do\_secret\_key) | n/a | `any` | n/a | yes |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | n/a | `any` | n/a | yes |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | n/a | `any` | n/a | yes |
| <a name="input_instellar_auth_token"></a> [instellar\_auth\_token](#input\_instellar\_auth\_token) | n/a | `any` | n/a | yes |
| <a name="input_instellar_host"></a> [instellar\_host](#input\_instellar\_host) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->