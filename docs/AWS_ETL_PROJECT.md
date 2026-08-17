# AWS ETL Sales Project

## 1. Project Overview

This project implements an event-driven AWS ETL pipeline for processing sales CSV files.

The project was initially created using AWS services manually and was then converted into Infrastructure as Code using Terraform.

The final Terraform configuration uses reusable modules for the major AWS resources.

The pipeline follows this flow:

```text
User uploads CSV
       |
       v
S3 Raw Bucket
       |
       | ObjectCreated event
       v
AWS Lambda
       |
       | Starts Glue Job
       v
AWS Glue ETL
       |
       | Reads transformation rules
       v
DynamoDB
       |
       | Transformation
       v
S3 Processed Bucket
       |
       v
Athena / Data Analysis
2. Project Architecture

The main AWS services used are:

Amazon S3
AWS Lambda
AWS Glue
Amazon DynamoDB
AWS Glue Data Catalog
Amazon Athena
AWS IAM
Amazon CloudWatch

The main data flow is:

                    sales.csv
                        |
                        v
              +-------------------+
              |   S3 Raw Bucket   |
              +-------------------+
                        |
                        | S3 ObjectCreated
                        v
              +-------------------+
              |   AWS Lambda      |
              |   etl-job-trigger |
              +-------------------+
                        |
                        | Start Glue Job
                        v
              +-------------------+
              |   AWS Glue ETL    |
              | etl-sales-transform
              +-------------------+
                   |          |
                   |          |
                   |          v
                   |   +----------------------+
                   |   | DynamoDB             |
                   |   | TransformationRules  |
                   |   +----------------------+
                   |
                   v
          +-----------------------+
          | S3 Processed Bucket   |
          +-----------------------+
                   |
                   v
          +-----------------------+
          | Athena / Query Layer  |
          +-----------------------+
3. S3 Buckets

Three S3 buckets are used in the project.

3.1 Raw Bucket
etl-project-sales-raw-alan

Purpose:

Receives the original sales CSV files.
Acts as the input location for the ETL pipeline.
Generates an S3 ObjectCreated event when a CSV file is uploaded.

Example input:

s3://etl-project-sales-raw-alan/sales.csv
3.2 Processed Bucket
etl-project-sales-processed-alan

Purpose:

Stores the transformed sales data.
Acts as the output location for the Glue ETL job.
3.3 Scripts Bucket
etl-project-sales-scripts-alan

Purpose:

Stores the AWS Glue ETL script used by the Glue job.

The Glue script is stored at:

s3://etl-project-sales-scripts-alan/glue/etl-sales-transform.py
4. Lambda Function

Lambda function:

etl-job-trigger

Runtime:

Python 3.14

Handler:

lambda_function.lambda_handler

IAM role:

LambdaETLRole

The Lambda source code is maintained locally at:

backend/aws/lambda/lambda_function.py

The deployment ZIP is:

backend/aws/lambda/lambda_function.zip
Lambda Responsibilities

The Lambda function:

Receives the S3 event.
Identifies the uploaded file.
Validates the file.
Reads information about the uploaded S3 object.
Reads the transformation configuration from DynamoDB.
Starts the AWS Glue ETL job.
Passes the input file information to the Glue job.
5. S3 to Lambda Trigger

The raw S3 bucket is configured with an S3 bucket notification.

Event:

s3:ObjectCreated:*

File filter:

.csv

Therefore, when a CSV file is uploaded to the raw bucket, Lambda is triggered.

The connection is:

S3 Raw Bucket
      |
      | ObjectCreated *.csv
      v
etl-job-trigger Lambda

The Terraform resource is managed through the reusable:

modules/s3_notification/

module.

6. DynamoDB Transformation Rules

DynamoDB table:

TransformationRules

Partition key:

RuleId

The table contains configuration that determines how the Glue ETL job transforms the sales data.

The advantage of storing transformation rules in DynamoDB is that transformation logic can be controlled through configuration rather than hardcoding every transformation directly into the ETL pipeline.

7. Transformation Rule - RULE001

Rule ID:

RULE001

Operation:

UPPERCASE

Column:

ProductName

Description:

Convert product names to uppercase

Example:

Laptop

becomes:

LAPTOP

The DynamoDB rule is:

{
  "RuleId": {
    "S": "RULE001"
  },
  "Column": {
    "S": "ProductName"
  },
  "Description": {
    "S": "Convert product names to uppercase"
  },
  "Operation": {
    "S": "UPPERCASE"
  }
}
8. Transformation Rule - RULE002

Rule ID:

RULE002

Operation:

MULTIPLY

Column 1:

Quantity

Column 2:

Price

Output column:

TotalPrice

Description:

Calculate total price

The DynamoDB rule is:

{
  "RuleId": {
    "S": "RULE002"
  },
  "Column1": {
    "S": "Quantity"
  },
  "Column2": {
    "S": "Price"
  },
  "Description": {
    "S": "Calculate total price"
  },
  "Operation": {
    "S": "MULTIPLY"
  },
  "OutputColumn": {
    "S": "TotalPrice"
  }
}

The transformation is:

TotalPrice = Quantity × Price

Example:

Quantity = 5
Price    = 100

TotalPrice = 5 × 100

TotalPrice = 500
9. AWS Glue ETL Job

Glue job:

etl-sales-transform

Glue version:

5.1

Worker type:

G.1X

Number of workers:

2

Timeout:

10 minutes

Maximum retries:

0

IAM role:

GlueETLRole

The Glue source code is maintained locally at:

backend/aws/glue/etl-sales-transform.py

The deployed copy is stored in S3:

s3://etl-project-sales-scripts-alan/glue/etl-sales-transform.py
10. Glue ETL Processing

The Glue job performs the following operations:

Receives the input file name.
Reads the sales CSV from the raw S3 bucket.
Reads transformation rules from DynamoDB.
Applies the configured transformations.
Produces the transformed dataset.
Writes the transformed data to the processed S3 bucket.

The ETL script uses:

Python
boto3
AWS Glue utilities
PySpark
GlueContext
Spark DataFrames
11. Glue Script Deployment

The authoritative Glue source code is:

backend/aws/glue/etl-sales-transform.py

It is uploaded to the S3 scripts bucket using:

scripts/aws/glue/upload-glue-script.ps1

The deployment flow is:

backend/aws/glue/etl-sales-transform.py
              |
              | upload-glue-script.ps1
              v
S3 Scripts Bucket
              |
              v
AWS Glue Job

This prevents having multiple copies of the Glue source code in the project.

12. Lambda Code Organization

The Lambda application source code is maintained under:

backend/aws/lambda/

Files:

lambda_function.py
lambda_function.zip

The Python file contains the Lambda handler.

The ZIP file is used by Terraform to deploy the Lambda function.

13. Terraform Infrastructure

Terraform infrastructure is located at:

aws/terraform/

The root Terraform files are:

aws/terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
└── versions.tf

Environment-specific variables are stored under:

aws/terraform/environments/dev/

with:

terraform.tfvars
14. Terraform Modules

Reusable Terraform modules are used to manage the AWS resources.

Current modules:

modules/
├── s3/
├── dynamodb/
├── glue_database/
├── glue_job/
├── lambda/
└── s3_notification/

Each reusable module contains:

main.tf
variables.tf
outputs.tf

This provides a consistent structure for reusable infrastructure.

15. S3 Terraform Module

The S3 module is reused for three buckets.

The root module uses for_each so that the same module can create/manage:

raw
processed
scripts

Terraform module addresses are:

module.s3["raw"]
module.s3["processed"]
module.s3["scripts"]

This avoids creating three separate copies of the same S3 Terraform resource definition.

16. DynamoDB Terraform Module

The DynamoDB module manages:

TransformationRules

The module receives values from the root module including:

table name
billing mode
hash key
hash key type
tags

The current table uses:

RuleId

as the partition key.

17. Glue Database Module

The project currently contains a Glue Data Catalog database:

sales_db

This resource is managed through:

modules/glue_database/

The Glue database was originally created/imported as part of the AWS infrastructure.

The current implementation therefore contains the Glue Data Catalog database.

If the final trainer requirement is to replace this with a separate database service, that should be treated as a separate architecture change rather than silently changing the documentation.

18. Glue Job Terraform Module

The Glue job is managed through:

modules/glue_job/

The module receives configuration including:

job name
IAM role
Glue version
execution class
worker type
number of workers
timeout
maximum retries
script location
default arguments

The script location is:

s3://etl-project-sales-scripts-alan/glue/etl-sales-transform.py
19. Lambda Terraform Module

The Lambda function is managed through:

modules/lambda/

The module receives:

function name
IAM role
handler
runtime
filename

The Lambda ZIP path is:

../../backend/aws/lambda/lambda_function.zip

The module also calculates the source code hash using:

filebase64sha256(var.filename)

This allows Terraform to detect changes to the Lambda deployment package.

20. S3 Notification Terraform Module

The S3 notification is managed through:

modules/s3_notification/

It connects:

S3 Raw Bucket

to:

etl-job-trigger Lambda

The notification listens for:

s3:ObjectCreated:*

and filters for:

.csv
21. Root Terraform Variables

Important configuration values are defined in:

aws/terraform/variables.tf

Examples include:

aws_region
project_name
environment
raw_bucket_name
processed_bucket_name
scripts_bucket_name
dynamodb_table_name

Environment-specific values are supplied through:

aws/terraform/environments/dev/terraform.tfvars

Example:

aws_region   = "us-east-1"
project_name = "ETL Project"
environment  = "dev"
22. Environment Variables File

The development environment uses:

environments/dev/terraform.tfvars

Terraform is executed with:

C:\Tools\Terraform\terraform.exe plan `
    -var-file="environments/dev/terraform.tfvars"

and:

C:\Tools\Terraform\terraform.exe apply `
    -var-file="environments/dev/terraform.tfvars"

The environment-specific values are separated from the reusable Terraform modules.

23. Terraform Outputs

Reusable modules expose useful resource information through outputs.tf.

For example, the Lambda module exposes:

output "function_arn" {
  value = aws_lambda_function.this.arn
}

The S3 module exposes the bucket name so other modules can reference it.

For example:

module.s3["raw"].bucket_name

The S3 notification module uses these module outputs to connect the raw bucket to Lambda.

24. Terraform Import Process

The AWS infrastructure was initially created manually.

The resources were then imported into Terraform.

The general process was:

1. Create AWS resource
2. Create matching Terraform resource
3. Import the existing resource
4. Inspect Terraform state
5. Match Terraform configuration with the real AWS configuration
6. Convert resources into reusable modules
7. Move Terraform state to module addresses
8. Run terraform plan
9. Fix configuration differences
10. Verify no unexpected changes
25. Imported Terraform Resources

The initial Terraform state contained resources including:

aws_dynamodb_table.transformation_rules
aws_glue_catalog_database.sales_db
aws_glue_job.etl_sales_transform
aws_lambda_function.etl_job_trigger
aws_s3_bucket.processed
aws_s3_bucket.raw
aws_s3_bucket.scripts
aws_s3_bucket_notification.raw_lambda

These resources were then migrated into reusable modules.

26. Terraform State Migration

When resources were converted into modules, Terraform state was moved from the old root resource address to the new module address.

Example:

C:\Tools\Terraform\terraform.exe state mv `
'aws_glue_catalog_database.sales_db' `
'module.glue_database.aws_glue_catalog_database.this'

This tells Terraform that the existing AWS resource is now managed by the module.

It prevents Terraform from treating the resource as a completely new resource.

27. Terraform State Inspection

The Terraform state can be inspected using:

C:\Tools\Terraform\terraform.exe state list

A specific resource can be inspected using:

C:\Tools\Terraform\terraform.exe state show <resource-address>

Example:

C:\Tools\Terraform\terraform.exe state show aws_glue_job.etl_sales_transform

This was useful for retrieving the actual AWS configuration before creating the reusable module.

28. Terraform Commands
Initialize
C:\Tools\Terraform\terraform.exe init
Format
C:\Tools\Terraform\terraform.exe fmt
Validate
C:\Tools\Terraform\terraform.exe validate
Plan
C:\Tools\Terraform\terraform.exe plan `
    -var-file="environments/dev/terraform.tfvars"
Apply
C:\Tools\Terraform\terraform.exe apply `
    -var-file="environments/dev/terraform.tfvars"
State List
C:\Tools\Terraform\terraform.exe state list
29. Terraform Helper Scripts

Terraform helper scripts are stored under:

scripts/aws/terraform/

Files:

aws-check.ps1
terraform-init.ps1
terraform-plan.ps1
terraform-apply.ps1
terraform-state.ps1

These scripts make common Terraform and AWS verification commands easier to execute.

30. AWS Verification Script

The script:

scripts/aws/terraform/aws-check.ps1

can be used to verify AWS resources.

It checks:

S3 buckets
DynamoDB tables
Glue jobs
Glue databases
Lambda functions

The AWS region used by the project is:

us-east-1
31. Glue Upload Script

The Glue deployment helper is:

scripts/aws/glue/upload-glue-script.ps1

Its purpose is to upload:

backend/aws/glue/etl-sales-transform.py

to:

s3://etl-project-sales-scripts-alan/glue/etl-sales-transform.py

This keeps the source code and deployment process separate.

32. Project Folder Organization

The project separates application code, scripts, documentation, and infrastructure.

Final structure:

devops-training-alan2/
│
├── backend/
│   └── aws/
│       ├── lambda/
│       │   ├── lambda_function.py
│       │   └── lambda_function.zip
│       │
│       └── glue/
│           └── etl-sales-transform.py
│
├── scripts/
│   └── aws/
│       ├── terraform/
│       │   ├── aws-check.ps1
│       │   ├── terraform-apply.ps1
│       │   ├── terraform-init.ps1
│       │   ├── terraform-plan.ps1
│       │   └── terraform-state.ps1
│       │
│       └── glue/
│           └── upload-glue-script.ps1
│
├── docs/
│   └── AWS_ETL_PROJECT.md
│
└── aws/
    └── terraform/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── provider.tf
        ├── versions.tf
        │
        ├── environments/
        │   └── dev/
        │       └── terraform.tfvars
        │
        └── modules/
            ├── s3/
            │   ├── main.tf
            │   ├── variables.tf
            │   └── outputs.tf
            │
            ├── dynamodb/
            │   ├── main.tf
            │   ├── variables.tf
            │   └── outputs.tf
            │
            ├── glue_database/
            │   ├── main.tf
            │   ├── variables.tf
            │   └── outputs.tf
            │
            ├── glue_job/
            │   ├── main.tf
            │   ├── variables.tf
            │   └── outputs.tf
            │
            ├── lambda/
            │   ├── main.tf
            │   ├── variables.tf
            │   └── outputs.tf
            │
            └── s3_notification/
                ├── main.tf
                ├── variables.tf
                └── outputs.tf

    34. Final Terraform Validation

After the resources were imported, modularized, and configured, Terraform was run against the development environment.

Final result:

No changes. Your infrastructure matches the configuration.

This confirms that Terraform's configuration matches the existing AWS infrastructure.

35. Current Project Status

The following components have been completed:

 S3 raw bucket
 S3 processed bucket
 S3 scripts bucket
 DynamoDB TransformationRules table
 DynamoDB transformation rules
 Lambda function
 Lambda source code
 Lambda deployment ZIP
 S3 to Lambda notification
 Glue ETL job
 Glue ETL source code
 Glue script deployment to S3
 Glue Data Catalog database
 Terraform imports
 Terraform reusable modules
 S3 for_each implementation
 Terraform state migration
 Root Terraform variables
 Development terraform.tfvars
 Terraform outputs
 Terraform helper scripts
 AWS verification script
 Project documentation
 Terraform configuration synchronized with AWS
36. Final Terraform Status

The final Terraform plan reports:

Plan: 0 to add, 0 to change, 0 to destroy.

and:

No changes. Your infrastructure matches the configuration.

This means the current Terraform configuration is synchronized with the existing AWS infrastructure.

37. Conclusion

This project demonstrates an event-driven AWS ETL pipeline combined with Infrastructure as Code.

The project was first created and configured in AWS and then imported into Terraform.

The Terraform configuration was subsequently refactored into reusable modules.

The final project separates responsibilities into four major areas:

backend/
    Application and ETL source code

scripts/
    Automation and deployment helper scripts

docs/
    Project documentation

aws/terraform/
    Infrastructure as Code

The resulting structure provides:

Reusable Terraform modules
Environment-specific configuration
Centralized transformation rules
Event-driven ETL processing
Separate application and infrastructure code
Repeatable deployment commands
Documented Terraform state migration
Clear project organization            