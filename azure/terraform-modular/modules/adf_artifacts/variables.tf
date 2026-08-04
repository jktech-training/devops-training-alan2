variable "data_factory_id" {
  type = string
}

variable "blob_connection_string" {
  type      = string
  sensitive = true
}

variable "cosmos_connection_string" {
  type      = string
  sensitive = true
}



variable "linked_service_name" {
  type = string
}