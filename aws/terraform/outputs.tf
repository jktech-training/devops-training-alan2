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

output "etl_glue_role_name" {
  value = module.etl_glue_role.role_name
}



output "transformation_rules_table_name" {
  value = module.transformation_rules.table_name
}

output "transformation_rules_table_arn" {
  value = module.transformation_rules.table_arn
}

output "glue_database_name" {
  value = module.etl_database.database_name
}

output "raw_sales_crawler_name" {
  value = module.raw_sales_crawler.crawler_name
}

output "processed_sales_crawler_name" {
  value = module.processed_sales_crawler.crawler_name
}
