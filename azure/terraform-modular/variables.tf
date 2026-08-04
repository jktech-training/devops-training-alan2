variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subscription_id" {
  type = string
}


variable "cosmos_connection_string" {
  type      = string
  sensitive = true
}

variable "blob_connection_string" {
  type      = string
  sensitive = true
}