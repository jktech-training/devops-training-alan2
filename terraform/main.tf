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