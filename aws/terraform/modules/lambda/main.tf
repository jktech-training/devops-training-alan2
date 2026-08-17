resource "aws_lambda_function" "this" {
  function_name = var.function_name

  role    = var.role_arn
  handler = var.handler
  runtime = var.runtime

  filename = var.filename

  source_code_hash = filebase64sha256(var.filename)

  architectures = ["x86_64"]

  memory_size = 128
  timeout     = 59

  ephemeral_storage {
    size = 512
  }

  tracing_config {
    mode = "PassThrough"
  }

  logging_config {
    log_format = "Text"
  }
}