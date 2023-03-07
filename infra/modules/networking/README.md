# Java multizone networking module

### Tagline
This module deploys the networking resources required for this HSA

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| firewall\_source\_ranges | The firewall will apply only to traffic that has source IP address in these ranges. These ranges must be expressed in CIDR format. | `list(string)` | `[]` | no |
| project\_id | GCP project ID. | `string` | n/a | yes |
| region | The region chosen to be used. | `string` | n/a | yes |
| xwiki\_vm\_tag | Tag for targeting FW rule | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| xwiki\_private\_network | VPC network |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
