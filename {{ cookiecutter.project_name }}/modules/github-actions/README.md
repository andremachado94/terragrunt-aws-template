# Github Actions Setup Module

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_branch"></a> [apply\_branch](#input\_apply\_branch) | Apply branch | `string` | `"main"` | no |
| <a name="input_openid_connect_provider"></a> [openid\_connect\_provider](#input\_openid\_connect\_provider) | OpenID Connect Provider Configuration | <pre>object({<br>    enabled         = bool,<br>    thumbprint_list = list(string)<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "thumbprint_list": []<br>}</pre> | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to apply to all resources | `string` | n/a | yes |
| <a name="input_repository"></a> [repository](#input\_repository) | Github repository name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apply_role_arn"></a> [apply\_role\_arn](#output\_apply\_role\_arn) | n/a |
| <a name="output_apply_role_name"></a> [apply\_role\_name](#output\_apply\_role\_name) | n/a |
| <a name="output_plan_role_arn"></a> [plan\_role\_arn](#output\_plan\_role\_arn) | n/a |
| <a name="output_plan_role_name"></a> [plan\_role\_name](#output\_plan\_role\_name) | n/a |
| <a name="output_release_role_arn"></a> [release\_role\_arn](#output\_release\_role\_arn) | n/a |
| <a name="output_release_role_name"></a> [release\_role\_name](#output\_release\_role\_name) | n/a |
<!-- END_TF_DOCS -->
