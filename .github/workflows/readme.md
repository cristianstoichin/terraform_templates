## Overview

This directory includes the 3 Github actions jobs that can be used to deploy the required infrastructure to host the React SPA application in AWS. The jobs must be run in order for they will require resource Ids to be updated before running them.

### [deploy-certificate.yml](1.deploy-certificate.yml)

The Github Action job allows you to either Plan, Deploy or Destroy the Terraform template. You must also setup the region where you want it to be deployed in [dev.tfvars](https://github.com/cristianstoichin/terraform_templates/blob/main/infrastructure/terraform/1.cert/variables/dev.tfvars#L1). In this case, because we want to use the Certificate with a Cloudfront distribution, `the certificate MUST be deployed to us-east-1` (global). 

This Github Action is designed to create a new SSL certificate in AWS Certificate Manager, which will enable SSL connectivity for our website. Remember --> `us-east-1` 

Before running the Job (manual trigger), you must first have the following Github Repo Secrets setup:

1. `DEPLOYMENT_ROLE_ARN`
   - This must be an existing Role in your AWS account that will allow the job to run the `aws cloudformation deploy` command.
      - Typically, this role is granted Admin permissions in AWS. However, be aware that this could pose a security risk. AWS recommends using the least privileged permissions for enhanced security.
2. `HostedZoneName`
   - This is a pre-requisite before running the deployment. You must have a Route53 hosted zone (public) that will be used to validate the ssl certificate.
3. `SubDomainName` this can also be a secret but in this example I simply hardcoded the value. This must be your desired subdomain name for the website. Ex: react-demo.  

### [deploy-vpc-infra.yml](deploy-vpc-infra.yml)

The Github Action job allows you to either Validate, Deploy or Destroy the vpc terraform template. You must also select a region where you want it to be deployed. 

This Github Action is designed to create the resources defined [here](https://github.com/cristianstoichin/terraform_templates/blob/main/infrastructure/readme.md)

Before running the Job (manual trigger), you must first have the following Github Repo Secrets setup:

1. `DEPLOYMENT_ROLE_ARN`
   - This must be an existing Role in your AWS account that will allow the job to run the `aws cloudformation deploy` command.
      - Typically, this role is granted Admin permissions in AWS. However, be aware that this could pose a security risk. AWS recommends using the least privileged permissions for enhanced security.

        
#### AWS Route53 Example

<p align="center">
  <img src="../../assets/hosted-zone.png" alt="Ec2">
</p>

#### Github Secrets Example

<p align="center">
  <img src="../../assets/secrets.png" alt="Ec2">
</p>
