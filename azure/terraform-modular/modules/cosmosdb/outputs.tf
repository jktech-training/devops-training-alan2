output "account_name" {
  value = azurerm_cosmosdb_account.this.name
}

output "account_id" {
  value = azurerm_cosmosdb_account.this.id
}

output "database_name" {
  value = azurerm_cosmosdb_sql_database.this.name
}

output "container_name" {
  value = azurerm_cosmosdb_sql_container.this.name
}