output "raw_bucket_name" {
  description = "Name of the raw S3 bucket"
  value       = module.raw_bucket.bucket_name
}

output "raw_bucket_arn" {
  description = "ARN of the raw S3 bucket"
  value       = module.raw_bucket.bucket_arn
}

output "processed_bucket_name" {
  description = "Name of the processed S3 bucket"
  value       = module.processed_bucket.bucket_name
}

output "processed_bucket_arn" {
  description = "ARN of the processed S3 bucket"
  value       = module.processed_bucket.bucket_arn
}

output "athena_results_bucket_name" {
  description = "Name of the Athena results S3 bucket"
  value       = module.athena_results_bucket.bucket_name
}

output "athena_results_bucket_arn" {
  description = "ARN of the Athena results S3 bucket"
  value       = module.athena_results_bucket.bucket_arn
}