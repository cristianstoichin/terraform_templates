vpc_id = "vpc-054709c84e8edd016"
region = "us-west-2"
environment = "dev"
application = "demo-ecs-fargate"
#Using the default secretsmanager key. If you have a customer key, switch to that instead.
kms_encryption_key = "aws/rds"
log_retention = 90
initial_image="ghcr.io/cristianstoichin/node-health:latest"
min_task_count = 1
max_task_count = 4
dns_name = "dash-demo.click"
sub_domain = "backend"
zone_id = "Z0472296JVGPZSZ5W16R"
created = 1664206819
timestamp = 1664206819
health_check_url = "/health"
scale_out_cooldown = 600
scale_in_cooldown = 600