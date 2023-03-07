# Java multizone loadbalancer module

### Tagline
This module deploys the loadbalancers required for this HSA

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | GCP project ID in which the auto-scaler group is created in. | `string` | n/a | yes |
| xwiki\_lb\_port\_name | Xwiki LB backend port name | `string` | n/a | yes |
| xwiki\_mig | Xwiki managed instance group | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| lb\_global\_ip | Frontend IP address of the load balancer |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
