variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN used by Lambda"
  type        = string
}

variable "handler" {
  description = "Lambda handler function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.12"
}

variable "filename" {
  description = "Path to Lambda deployment zip file"
  type        = string
}

variable "timeout" {
  description = "Lambda execution timeout"
  type        = number
  default     = 60
}

variable "memory_size" {
  description = "Lambda memory allocation"
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "Environment variables for Lambda"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}