# Java multizone database module

### Tagline
This module deploys the database required for this HSA

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_type | The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL). | `string` | n/a | yes |
| private\_network\_id | VPC id | `string` | n/a | yes |
| project\_id | The project ID to manage the Cloud SQL resources. | `string` | n/a | yes |
| region | The region of the Cloud SQL resource. | `string` | n/a | yes |
| service\_account | Service Account which should have read permission to access the database password. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| db\_ip | The IPv4 address assigned for the master instance |
| password\_secret | Name of the secret storing the database password |
| xwiki\_user | SQL username for XWiki |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
