variable "job_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "glue_version" {
  type = string
}

variable "execution_class" {
  type = string
}

variable "worker_type" {
  type = string
}

variable "number_of_workers" {
  type = number
}

variable "timeout" {
  type = number
}

variable "max_retries" {
  type = number
}

variable "default_arguments" {
  type = map(string)
}

variable "script_location" {
  type = string
}