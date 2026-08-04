# Azure ETL Pipeline using Terraform

## Project Overview

This project demonstrates the implementation of an end-to-end ETL (Extract, Transform, Load) pipeline on Microsoft Azure using Infrastructure as Code (IaC) with Terraform.

The project was developed to replicate an existing AWS ETL solution using Azure-native services while following modular Terraform design and industry best practices.

A key objective of this project was to manually provision Azure resources, import them into Terraform state, and eliminate all infrastructure drift until every resource reported:

```text
No changes. Your infrastructure matches the configuration.
```

---

# Architecture

```
                 sales.csv
                     │
                     ▼
        Azure Storage Account
             (raw container)
                     │
                     ▼
        Azure Data Factory Pipeline
             (PL_SalesETL)
                     │
                     ▼
     Azure Mapping Data Flow
        (DF_SalesTransform)
                     │
                     ▼
      Transformations Performed
        • Convert Name to Uppercase
        • Additional transformation logic
                     │
                     ▼
        Azure Storage Account
         (processed container)

                 ▲
                 │
            Cosmos DB
     Transformation Rules

                 ▲
                 │
      Schedule Trigger
      (Runs Every Hour)
```

---

# Azure Services Used

| Service               | Purpose                               |
| --------------------- | ------------------------------------- |
| Azure Resource Group  | Logical grouping of resources         |
| Azure Storage Account | Stores raw and processed datasets     |
| Blob Containers       | raw, processed, scripts, synapse      |
| Azure Cosmos DB       | Stores transformation rules           |
| Azure Data Factory    | ETL orchestration                     |
| Linked Services       | Connect Storage Account and Cosmos DB |
| Datasets              | Define source and destination files   |
| Mapping Data Flow     | Data transformation                   |
| Pipeline              | Executes ETL workflow                 |
| Schedule Trigger      | Executes pipeline every hour          |

---

# Project Structure

```
azure/
└── terraform-modular/
    ├── main.tf
    ├── provider.tf
    ├── versions.tf
    ├── variables.tf
    ├── outputs.tf
    │
    ├── environments/
    │   └── dev/
    │       └── terraform.tfvars
    │
    └── modules/
        ├── resource_group/
        ├── storage_account/
        ├── storage_container/
        ├── cosmosdb/
        ├── data_factory/
        └── adf_artifacts/
```

---

# Terraform Modules

## Resource Group

Creates the Azure Resource Group used by the project.

---

## Storage Account

Creates the Azure Storage Account and supports:

* Raw container
* Processed container
* Scripts container
* Synapse container

---

## Cosmos DB

Creates:

* Cosmos DB Account
* SQL Database
* SQL Container

Used to store ETL transformation rules.

---

## Azure Data Factory

Creates:

* Azure Data Factory instance

---

## Azure Data Factory Artifacts

Manages:

* Blob Storage Linked Service
* Cosmos DB Linked Service
* Source Dataset
* Processed Dataset
* Mapping Data Flow
* Pipeline
* Schedule Trigger

---

# ETL Workflow

1. Upload `sales.csv` into the **raw** container.
2. Schedule Trigger starts the pipeline every hour.
3. Pipeline executes the Mapping Data Flow.
4. Data Flow reads data from the raw dataset.
5. Transformations are applied.
6. Processed data is written to the **processed** container.
7. Cosmos DB stores transformation rules used by the ETL process.

---

# Infrastructure Managed by Terraform

## Infrastructure

* Resource Group
* Storage Account
* Storage Containers
* Cosmos DB Account
* Cosmos DB Database
* Cosmos DB Container

## Azure Data Factory

* Data Factory
* Blob Storage Linked Service
* Cosmos DB Linked Service
* Source Dataset
* Processed Dataset
* Mapping Data Flow
* Pipeline
* Schedule Trigger

---

# Importing Existing Infrastructure

Instead of recreating resources, existing Azure resources were imported into Terraform using:

```bash
terraform import
```

After importing, Terraform configurations were updated until every imported resource reached:

```
No changes. Your infrastructure matches the configuration.
```

This process included:

* Linked Services
* Datasets
* Mapping Data Flow
* Pipeline
* Trigger

---

# Technologies Used

* Terraform
* Microsoft Azure
* Azure Resource Manager Provider (AzureRM)
* Azure Storage Account
* Azure Cosmos DB
* Azure Data Factory
* Azure CLI
* Git
* GitHub

---

# Challenges Faced

During the project, several real-world Terraform import issues were resolved, including:

* Importing Azure Data Factory resources
* Terraform state synchronization
* Linked Service drift
* Dataset configuration differences
* Pipeline JSON matching
* Mapping Data Flow configuration
* Trigger synchronization
* Sensitive connection string handling

---

# Key Learning Outcomes

* Infrastructure as Code using Terraform
* Modular Terraform architecture
* Azure Resource Manager concepts
* Terraform state management
* Terraform import workflow
* Azure Data Factory implementation
* Azure ETL orchestration
* Azure Storage integration
* Cosmos DB integration
* Troubleshooting Terraform drift

---

# Future Improvements

* Replace connection strings with Managed Identity authentication.
* Store secrets in Azure Key Vault.
* Deploy using GitHub Actions CI/CD.
* Add monitoring with Azure Monitor.
* Add Azure Function for event-driven execution.
* Extend ETL transformations using additional Data Flow logic.

---

# Author

**Alan K**

This project was developed as part of a DevOps and Cloud Engineering learning journey to gain hands-on experience with Azure Infrastructure as Code, Terraform, and ETL pipeline implementation.
