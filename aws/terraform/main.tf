module "s3" {
  source = "./modules/s3"

  for_each = {
    raw = {
      bucket_name = var.raw_bucket_name
    }

    processed = {
      bucket_name = var.processed_bucket_name
    }

    scripts = {
      bucket_name = var.scripts_bucket_name
    }
  }

  bucket_name = each.value.bucket_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

module "dynamodb" {
  source = "./modules/dynamodb"

  table_name    = var.dynamodb_table_name
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "RuleId"
  hash_key_type = "S"

  tags = {
    Project     = "ETL Project"
    Environment = "dev"
  }
}


module "glue_database" {
  source = "./modules/glue_database"

  database_name = var.glue_database_name
}

module "glue_job" {
  source = "./modules/glue_job"

  job_name        = var.glue_job_name
  role_arn        = "arn:aws:iam::938565868672:role/GlueETLRole"
  glue_version    = "5.1"
  execution_class = "STANDARD"

  worker_type       = "G.1X"
  number_of_workers = 2
  timeout           = 10
  max_retries       = 0

  script_location = "s3://etl-project-sales-scripts-alan/glue/etl-sales-transform.py"

  default_arguments = {
    "--INPUT_FILE"                       = "sales.csv"
    "--TempDir"                          = "s3://aws-glue-assets-938565868672-us-east-1/temporary/"
    "--conf"                             = "spark.sql.catalog.glue_catalog.glue.skip-name-validation=true"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-job-insights"              = "true"
    "--enable-observability-metrics"     = "true"
    "--job-bookmark-option"              = "job-bookmark-disable"
    "--job-language"                     = "python"
    "--spark-event-logs-path"            = "s3://aws-glue-assets-938565868672-us-east-1/sparkHistoryLogs/"
  }
}

module "s3_notification" {
  source = "./modules/s3_notification"

  bucket_name = module.s3["raw"].bucket_name

  lambda_function_arn = module.etl_lambda.function_arn
}

module "etl_lambda" {
  source = "./modules/lambda"

  function_name = var.lambda_function_name
  role_arn      = "arn:aws:iam::938565868672:role/LambdaETLRole"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.14"

  filename = "${path.module}/../../backend/aws/lambda/lambda_function.zip"
}