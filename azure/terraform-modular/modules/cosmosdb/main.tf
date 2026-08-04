resource "azurerm_cosmosdb_account" "this" {
  name                = var.account_name
  location            = var.location
  resource_group_name = var.resource_group_name

  offer_type = "Standard"
  kind       = "GlobalDocumentDB"

  free_tier_enabled          = true
  automatic_failover_enabled = true

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }
  lifecycle {
    ignore_changes = [
      tags["hidden-cosmos-mmspecial"]
    ]
  }
  tags = {
    defaultExperience    = "Core (SQL)"
    hidden-workload-type = "Learning"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "this" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
}

resource "azurerm_cosmosdb_sql_container" "this" {

  name                = var.container_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.this.name

  partition_key_paths = [
    "/id"
  ]

  partition_key_version = 2

  analytical_storage_ttl = 0
  default_ttl            = 0

  autoscale_settings {
    max_throughput = 1000
  }
}