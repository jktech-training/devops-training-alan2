aws_region   = "us-east-1"
project_name = "ETL Project"
environment  = "dev"

raw_bucket_name       = "etl-project-sales-raw-alan"
processed_bucket_name = "etl-project-sales-processed-alan"
scripts_bucket_name   = "etl-project-sales-scripts-alan"

dynamodb_table_name = "TransformationRules"

glue_database_name = "sales_db"
glue_job_name      = "etl-sales-transform"

lambda_function_name = "etl-job-trigger"