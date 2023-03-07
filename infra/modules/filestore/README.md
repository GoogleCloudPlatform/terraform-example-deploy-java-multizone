# Java multizone filestore module

### Tagline
This module deploys the filestore instance required for this HSA

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| private\_network\_id | VPC id | `string` | n/a | yes |
| zone | zone is used by filestore location, it depends on the region chosen. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| filestore\_ip | Filestore IP address |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
