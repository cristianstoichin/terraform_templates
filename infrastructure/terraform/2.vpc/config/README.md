The Terraform State configuration file for the various environments.

It has the following values:

- `bucket = "terraform-ops-demo-do-not-delete-state"`
- `key = "vpc-infra/dev/terraform.tfstate"`
- `encrypt  = false`

The `bucket` and `key` values specify the bucket name and subfolder in which the terraform state files get stored.

It is used on the terraform init step in the Github Action

- [Prod Deployment](TDB)
- [Non-Prod Deployment](TBD)

<p align="center">
  <img src="./assets/init-overview.png" alt="Init Overview">
</p>
