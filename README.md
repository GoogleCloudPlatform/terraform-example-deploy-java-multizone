# terraform-example-deploy-java-multizone

## Description

### Detailed

The resources/services/activations/deletions that this app will create/trigger are:

- Compute
- IAM
- Service Networking
- Cloud SQL
- Secret Manager

### PreDeploy

To deploy this blueprint you must have an active billing account and billing permissions.

## Documentation

- [Deploying a Java App](https://cloud.google.com/)

## Usage

Basic usage is as follows:


## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.0

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- roles/cloudsql.admin
- roles/file.editor
- roles/iam.serviceAccountUser
- roles/compute.admin
- roles/logging.admin
- roles/monitoring.admin
- roles/resourcemanager.projectIamAdmin
- roles/secretmanager.admin
- roles/iam.serviceAccountAdmin
- roles/servicenetworking.networksAdmin
- roles/storage.admin
- roles/serviceusage.serviceUsageAdmin
- roles/storage.hmacKeyAdmin

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- compute.googleapis.com
- file.googleapis.com
- iam.googleapis.com
- servicenetworking.googleapis.com
- sqladmin.googleapis.com
- secretmanager.googleapis.com
- cloudresourcemanager.googleapis.com
- config.googleapis.com

## Contributing

Refer to the [contribution guidelines](CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures

