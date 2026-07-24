variable "job_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "description" {
  type = string
}

variable "glue_version" {
  type    = string
  default = "5.1"
}

variable "script_location" {
  type = string
}

variable "default_arguments" {
  type = map(string)

  default = {
    "--job-language" = "python"
  }
}