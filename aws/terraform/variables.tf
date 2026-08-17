variable "aws_region" {
  description = "AWS region where resources are deployed"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the ETL project"
  type        = string
  default     = "ETL Project"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "raw_bucket_name" {
  description = "Name of the raw S3 bucket"
  type        = string
}

variable "processed_bucket_name" {
  description = "Name of the processed S3 bucket"
  type        = string
}

variable "scripts_bucket_name" {
  description = "Name of the scripts S3 bucket"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB transformation rules table"
  type        = string
}

variable "glue_database_name" {
  description = "Name of the Glue catalog database"
  type        = string
}

variable "glue_job_name" {
  description = "Name of the Glue ETL job"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda ETL trigger function"
  type        = string
}