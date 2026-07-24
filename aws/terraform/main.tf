module "raw_bucket" {
  source = "./modules/s3"

  bucket_name = "etl-project-sales-raw-alan"

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}

module "processed_bucket" {
  source = "./modules/s3"

  bucket_name = "etl-project-sales-processed-alan"

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}

module "athena_results_bucket" {
  source = "./modules/s3"

  bucket_name = "etl-project-athena-results-alan"

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}

module "etl_glue_role" {
  source = "./modules/iam"

  role_name = "etl-glue-role"

  description = "IAM role for Glue ETL Project"

  managed_policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"

  dynamodb_table_arn = module.transformation_rules.table_arn

  s3_bucket_arns = [
    module.raw_bucket.bucket_arn,
    module.processed_bucket.bucket_arn,
    module.athena_results_bucket.bucket_arn
  ]

  s3_object_arns = [
    "${module.raw_bucket.bucket_arn}/*",
    "${module.processed_bucket.bucket_arn}/*",
    "${module.athena_results_bucket.bucket_arn}/*"
  ]
}

module "transformation_rules" {
  source = "./modules/dynamodb"

  table_name = "TransformationRules"
  hash_key   = "RuleId"
}

module "etl_database" {
  source = "./modules/glue_database"

  database_name = "etl_database"
  description   = "Metadata catalog for the AWS ETL training project."
}

module "raw_sales_crawler" {
  source = "./modules/glue_crawler"

  crawler_name  = "etl-sales-crawler"
  role          = "etl-glue-role"
  database_name = "etl_database"
  description   = "Crawler for raw sales CSV"

  s3_path = "s3://etl-project-sales-raw-alan"
}

module "processed_sales_crawler" {
  source = "./modules/glue_crawler"

  crawler_name  = "processed-sales-crawler"
  role          = "etl-glue-role"
  database_name = "etl_database"
  description   = "crawler to detect the schema from the output or processed etl data from s3"

  s3_path = "s3://etl-project-sales-processed-alan/output/"
}

module "etl_sales_transform" {

  source = "./modules/glue_job"

  job_name = "etl-sales-transform"

  role_arn = "arn:aws:iam::938565868672:role/etl-glue-role"

  description     = "Reads raw sales data, applies transformations, writes processed CSV to S3."
  script_location = "s3://aws-glue-assets-938565868672-us-east-1/scripts/etl-sales-transform.py"

  glue_version = "5.1"

  default_arguments = {
    "--job-language"                     = "python"
    "--TempDir"                          = "s3://aws-glue-assets-938565868672-us-east-1/temporary/"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-job-insights"              = "false"
    "--enable-observability-metrics"     = "true"
    "--enable-spark-ui"                  = "true"
    "--job-bookmark-option"              = "job-bookmark-disable"
    "--spark-event-logs-path"            = "s3://aws-glue-assets-938565868672-us-east-1/sparkHistoryLogs/"
    "--conf"                             = "spark.eventLog.rolling.enabled=true --conf spark.sql.catalog.glue_catalog.glue.skip-name-validation=true"
  }
}

module "etl_lambda" {
  source = "./modules/lambda"

  function_name = "etl-job-trigger"

  role_arn = "arn:aws:iam::938565868672:role/etl-job-trigger-role-3bdw8jxf"

  handler = "lambda_function.lambda_handler"

  runtime = "python3.14"

  filename = "../lambda/etl-job-trigger/etl-job-trigger.zip"

  timeout = 3

  environment_variables = {}

  tags = {
    Project     = var.project_name
    Environment = "dev"
  }
}