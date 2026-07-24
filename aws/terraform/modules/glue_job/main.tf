resource "aws_glue_job" "this" {

  name         = var.job_name
  role_arn     = var.role_arn
  description  = var.description
  glue_version = var.glue_version

  execution_class = "STANDARD"

  worker_type       = "G.1X"
  number_of_workers = 2

  timeout     = 10
  max_retries = 0

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