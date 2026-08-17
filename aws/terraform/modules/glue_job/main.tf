resource "aws_glue_job" "this" {
  name     = var.job_name
  role_arn = var.role_arn

  glue_version   = var.glue_version
  execution_class = var.execution_class

  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers
  timeout           = var.timeout
  max_retries       = var.max_retries

  default_arguments = var.default_arguments

  command {
    name            = "glueetl"
    python_version  = "3"
    script_location = var.script_location
  }

  execution_property {
    max_concurrent_runs = 1
  }
}