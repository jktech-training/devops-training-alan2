resource "azurerm_data_factory_linked_service_azure_blob_storage" "blob_storage" {
  name            = "LS_BlobStorage"
  data_factory_id = var.data_factory_id

  connection_string_insecure = var.blob_connection_string

  use_managed_identity = true
}


resource "azurerm_data_factory_linked_service_cosmosdb" "cosmosdb" {
  name            = "LS_CosmosDB"
  data_factory_id = var.data_factory_id

  connection_string = var.cosmos_connection_string
}

resource "azurerm_data_factory_dataset_delimited_text" "sales_csv" {
  name                = "DS_SalesCSV"
  data_factory_id     = var.data_factory_id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.blob_storage.name

  azure_blob_storage_location {
    container = "raw"
    path      = ""
    filename  = "sales.csv"
  }

  column_delimiter    = ","
  first_row_as_header = true
}

resource "azurerm_data_factory_dataset_delimited_text" "processed_sales" {
  name                = "DS_ProcessedSales"
  data_factory_id     = var.data_factory_id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.blob_storage.name

  azure_blob_storage_location {
    container = "processed"
    path      = ""
    filename  = "sales_processed.csv"
  }

  column_delimiter    = ","
  first_row_as_header = true
}

resource "azurerm_data_factory_pipeline" "sales_etl" {
  name            = "PL_SalesETL"
  data_factory_id = var.data_factory_id

activities_json = jsonencode([
  {
    name = "Data flow1"

    type = "ExecuteDataFlow"

    dependsOn = []

    policy = {
      timeout                = "0.12:00:00"
      retry                  = 0
      retryIntervalInSeconds = 30
      secureInput            = false
      secureOutput           = false
    }

    typeProperties = {
      dataFlow = {
        referenceName = "DF_SalesTransform"
        type          = "DataFlowReference"

        parameters = {}

        datasetParameters = {
          SourceSales   = {}
          SinkProcessed = {}
        }
      }

      compute = {
        computeType = "General"
        coreCount   = 8
      }

      staging = {}

      traceLevel = "Fine"
    }

    userProperties = []
  }
])
}

resource "azurerm_data_factory_data_flow" "sales_transform" {
  name            = "DF_SalesTransform"
  data_factory_id = var.data_factory_id

  script_lines = [
    "source(output(",
    "          CustomerID as short,",
    "          Name as string,",
    "          Product as string,",
    "          Quantity as integer,",
    "          {Price } as double",
    "     ),",
    "     allowSchemaDrift: false,",
    "     validateSchema: true,",
    "     ignoreNoFilesFound: false) ~> SourceSales",
    "SourceSales derive(Name = upper(Name)) ~> TransformSales",
    "TransformSales sink(allowSchemaDrift: true,",
    "     validateSchema: false,",
    "     skipDuplicateMapInputs: true,",
    "     skipDuplicateMapOutputs: true) ~> SinkProcessed"
  ]

  source {
    name = "SourceSales"

    dataset {
      name = "DS_SalesCSV"
    }
  }

  transformation {
   name = "TransformSales"
  }

  sink {
    name = "SinkProcessed"

    dataset {
      name = "DS_ProcessedSales"
    }
  }
}

resource "azurerm_data_factory_trigger_schedule" "sales_etl" {
  name            = "TR_SalesETL"
  data_factory_id = var.data_factory_id

  frequency = "Hour"
  interval  = 1

  start_time = "2026-07-31T04:33:00Z"
  time_zone  = "India Standard Time"

  activated = true

  pipeline {
    name = "PL_SalesETL"

    parameters = {}
  }
}