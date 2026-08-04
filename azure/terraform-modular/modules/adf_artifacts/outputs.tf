output "sales_csv_id" {
  value = azurerm_data_factory_dataset_delimited_text.sales_csv.id
}

output "processed_sales_id" {
  value = azurerm_data_factory_dataset_delimited_text.processed_sales.id
}

output "pipeline_id" {
  value = azurerm_data_factory_pipeline.sales_etl.id
}

output "data_flow_id" {
  value = azurerm_data_factory_data_flow.sales_transform.id
}