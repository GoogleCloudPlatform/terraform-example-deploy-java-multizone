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
| availability\_type | The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL). | `string` | `"REGIONAL"` | no |
| firewall\_source\_ranges | The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format. | `list(string)` | <pre>[<br>  "130.211.0.0/22",<br>  "35.191.0.0/16"<br>]</pre> | no |
| labels | A map of key/value label pairs to assign to the resources. | `map(string)` | <pre>{<br>  "app": "terraform-example-deploy-java-gce"<br>}</pre> | no |
| project\_id | GCP project ID. | `string` | n/a | yes |
| region | Compute Region to deploy to. | `string` | `"us-central1"` | no |
| xwiki\_img\_info | Xwiki app image information. | <pre>object({<br>    image_project = string<br>    image_name    = string<br>  })</pre> | <pre>{<br>  "image_name": "hsa-xwiki-vm-img-latest",<br>  "image_project": "hsa-public"<br>}</pre> | no |
| zones | Compute Zones to deploy to. | `list(string)` | <pre>[<br>  "us-central1-a",<br>  "us-central1-b"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| neos\_walkthrough\_url | Neos Tutorial URL |
| xwiki\_entrypoint\_url | Shows the URL of XWiki's index page. |
| xwiki\_mig\_self\_link | MIG hosting XWiki |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
