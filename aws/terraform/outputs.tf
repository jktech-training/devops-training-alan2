output "raw_bucket_name" {
  description = "Name of the S3 raw bucket"
  value       = module.s3["raw"].bucket_name
}

output "processed_bucket_name" {
  description = "Name of the S3 processed bucket"
  value       = module.s3["processed"].bucket_name
}

output "scripts_bucket_name" {
  description = "Name of the S3 scripts bucket"
  value       = module.s3["scripts"].bucket_name
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB transformation rules table"
  value       = module.dynamodb.table_name
}

output "glue_database_name" {
  description = "Name of the Glue catalog database"
  value       = module.glue_database.database_name
}

output "glue_job_name" {
  description = "Name of the Glue ETL job"
  value       = module.glue_job.job_name
}

output "lambda_function_arn" {
  description = "ARN of the ETL Lambda function"
  value       = module.etl_lambda.function_arn
}