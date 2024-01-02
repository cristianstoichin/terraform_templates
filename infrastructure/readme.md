## Overview

This directory includes the terraform templates for the SSL certificate and the SPA infrastructure. These templates are executed by GitHub Actions to set up the necessary infrastructure for hosting the React SPA application.

### [SSL Cert Template](https://github.com/cristianstoichin/react-ci-cd-terraform/tree/main/infrastructure/terraform/1.cert)

This template is designed to create a new SSL certificate in AWS Certificate Manager, which will enable SSL connectivity for our website. 

The template is using the [dev.tfvars](https://github.com/cristianstoichin/terraform_templates/blob/main/infrastructure/terraform/1.cert/variables/dev.tfvars) as entry parameters. You will need to change these for your needs. 

`Before deploying this to your AWS account, you must have a pre-existing Route53 public hosted zone in place, which is required for validating the certificate.`

The templates are using this [configuration file](https://github.com/cristianstoichin/terraform_templates/blob/main/infrastructure/terraform/1.cert/config/backend-dev.hcl) to tell Terraform where the state files are stored. In this case, we use an S3 terraform backend. 

`Before deploying this to your AWS account, you must have a pre-existing S3 bucket created in your AWS account and change` [this value](https://github.com/cristianstoichin/terraform_templates/blob/main/infrastructure/terraform/1.cert/config/backend-dev.hcl#L1) `to your bucket's name.`

### [VPC Template](https://github.com/cristianstoichin/terraform_templates/tree/main/infrastructure/terraform/2.vpc)

This template is designed to create the following resources in your AWS account:

1. VPC
2. 3 Public Subnets
3. 3 Private Subnet
4. Internet Gateway
5. Nat Gateway
6. Elastic IP to associate with the Nat gateway.
7. Route table with routing for private subnets using Nat Gateway and routing for public subnets using Internet gateway.

The template is using the [dev.tfvars](https://github.com/cristianstoichin/terraform_templates/blob/main/infrastructure/terraform/2.vpc/variables/dev.tfvars) as entry parameters. You will need to change these for your needs. 

`Before deploying this to your AWS account, you must have a pre-existing Route53 public hosted zone in place, which is required for validating the certificate.`

The templates are using this [configuration file](https://github.com/cristianstoichin/terraform_templates/blob/main/infrastructure/terraform/2.vpc/config/backend-dev.hcl) to tell Terraform where the state files are stored. In this case, we use an S3 terraform backend. 

`Before deploying this to your AWS account, you must have a pre-existing S3 bucket created in your AWS account and change` [this value](https://github.com/cristianstoichin/terraform_templates/blob/main/infrastructure/terraform/2.vpc/config/backend-dev.hcl#L1) `to your bucket's name.`
