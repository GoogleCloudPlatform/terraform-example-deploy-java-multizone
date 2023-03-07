# Java multizone VM module

### Tagline
This module deploys the VM instances required for this HSA

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| private\_network\_id | VPC id | `string` | n/a | yes |
| project\_id | GCP project ID. | `string` | n/a | yes |
| region | The region chosen to be used. | `string` | n/a | yes |
| service\_account | Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles. | <pre>object({<br>    email  = string<br>    scopes = set(string)<br>  })</pre> | n/a | yes |
| startup\_script | The startup script to run when instances start up | `any` | `""` | no |
| xwiki\_img\_info | Xwiki app image information. | <pre>object({<br>    image_name    = string<br>    image_project = string<br>  })</pre> | n/a | yes |
| xwiki\_lb\_port\_name | Xwiki LB backend port name | `string` | n/a | yes |
| xwiki\_vm\_tag | Tag for targeting FW rule | `string` | n/a | yes |
| zones | A list of zones that mig can be placed in. The list depends on the region chosen. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| xwiki\_mig | Xwiki managed instance group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
