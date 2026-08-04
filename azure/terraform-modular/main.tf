module "resource_group" {
  source = "./modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
}

module "storage_account" {
  source = "./modules/storage_account"

  storage_account_name = "stetlprojectalan"
  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
}

module "raw_container" {
  source = "./modules/storage_container"

  container_name     = "raw"
  storage_account_id = module.storage_account.id
}

module "processed_container" {
  source = "./modules/storage_container"

  container_name     = "processed"
  storage_account_id = module.storage_account.id
}

module "scripts_container" {
  source = "./modules/storage_container"

  container_name     = "scripts"
  storage_account_id = module.storage_account.id
}

module "synapse_container" {
  source = "./modules/storage_container"

  container_name     = "synapse"
  storage_account_id = module.storage_account.id
}

module "cosmosdb" {
  source = "./modules/cosmosdb"

  account_name   = "cosmos-etl-alan"
  database_name  = "etl-db"
  container_name = "TransformationRules"

  resource_group_name = module.resource_group.name
  location            = "eastus2"
}

module "data_factory" {

  source = "./modules/data_factory"

  data_factory_name = "adf-etl-alan"

  resource_group_name = module.resource_group.name

  location = module.resource_group.location

  tags = {}
}

module "adf_artifacts" {
  source = "./modules/adf_artifacts"

  data_factory_id          = module.data_factory.id
  blob_connection_string   = var.blob_connection_string
  cosmos_connection_string = var.cosmos_connection_string
  linked_service_name      = "LS_BlobStorage"
}
