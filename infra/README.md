# XWiki Infrastructure

Sample HSA infrastructure.

### Tagline
Sample HSA infrastructure tagline.

### Detailed
Sample HSA infrastructure detailed description.

### Architecture
1. Compute Engine
1. Cloud SQL

## Documentation
- [Architecture Diagram](todo)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_type | The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL). | `string` | n/a | yes |
| firewall\_source\_ranges | The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format. | `list(string)` | n/a | yes |
| location | location contains a region and a list of zones (at least 2 zones must be selected). Zones depends on the region chosen. | <pre>object({<br>    region = string<br>    zones  = list(string)<br>    }<br>  )</pre> | n/a | yes |
| project\_id | GCP project ID. | `string` | n/a | yes |
| vm\_sa\_email | Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles. | `string` | n/a | yes |
| xwiki\_img\_info | Xwiki app image information. | <pre>object({<br>    image_name    = string<br>    image_project = string<br>  })</pre> | n/a | yes |
| xwiki\_sql\_user\_password | Default password for user xwiki | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| xwiki\_entrypoint\_url | Shows the URL of XWiki's index page. |
| xwiki\_mig\_self\_link | MIG hosting XWiki |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
