resource "aws_glue_crawler" "this" {
  name          = var.crawler_name
  role          = var.role
  database_name = var.database_name
  description   = var.description

  configuration = jsonencode({
    Version              = 1.0
    CreatePartitionIndex = true
  })

  s3_target {
    path = var.s3_path
  }

  schema_change_policy {
    delete_behavior = "DEPRECATE_IN_DATABASE"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }
}