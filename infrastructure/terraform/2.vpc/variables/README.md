The Terraform Variables files for the 2 deployable environments:

- [Prod - us-west-2 (Oregon)](TBD)
- [Non-Prod - us-west-2 (Oregon)](TBD)

All the files have the following declared values for the variables:

- `region = {your_region} - EX: us-east-1/us-west-2 etc`
  - This is the primary region where your stack will be deployed to.
- `environment = stage/prod/non-prod/etc`
  - This variable will be appended to the resources name - EX: wikijs-database.db.pwd.prod.1655742047.json (Secrets Manager)
- `vpc_cidr = 10.10.0.0/16`
  - The VPC CIDR Range.
- `public_subnet_1_cidr="10.10.0.0/24"`
  - Public subnet CIDR Range
- `public_subnet_2_cidr="10.10.16.0/24"`
  - Public subnet CIDR Range
- `public_subnet_3_cidr="10.10.32.0/24"`
  - Public subnet CIDR Range
- `private_subnet_1_cidr="10.10.48.0/24"`
  - Private subnet CIDR Range
- `private_subnet_2_cidr="10.10.64.0/24"`
  - Private subnet CIDR Range
- `private_subnet_3_cidr="10.10.80.0/24"`
  - Private subnet CIDR Range
- `enable_third_subnet = false`
  - true/false - use this to control if you want a 3rd subnet created for high availability. To save on cost keep it false (non prod)
- `single_nat = true`
  - true/false - use this to control if you want to only have 1 NAT gateway for all private subnets. To save on cost keep it true (non prod) 
- `created = Unix Epoch Timestamp`
  - This is a way to provide a unique ID for the generated resources.
  - It's required for the Secret manager resources we create, that can't be reused for 7 days if we delete them and try to recreate them.
- `timestamp = Update_TimeStamp`
  - This value is used to update the Resources Last_Updated tag in AWS.
