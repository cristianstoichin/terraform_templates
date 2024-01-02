output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       =  "arn:aws:s3:::${var.application}-${var.environment}-${var.created}-access"
}

output "s3_bucket_name" {
  description = "The name of the bucket."
  value       =  "${var.application}-${var.region}-${var.environment}-${var.created}-access"
}

output "s3_bucket_id" {
  description = "The id of the bucket."
  value       =  aws_s3_bucket.this.id
}