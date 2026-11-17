terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.50.0"
    }
  }
}

variable "environment" {
  default = "sbx"
}

variable "cost_center" {
  default = "CC-1001"
}

resource "databricks_cluster" "finops_governed_cluster" {
  cluster_name            = "cls-analytics-${var.environment}-01"
  spark_version           = "15.4.x-scala2.12"
  node_type_id            = "Standard_D4ds_v5"
  autotermination_minutes = 15

  autoscale {
    min_workers = 1
    max_workers = 4
  }

  azure_attributes {
    availability = var.environment == "sbx" ? "SPOT_WITH_FALLBACK_AZURE" : "ON_DEMAND_AZURE"
  }

  custom_tags = {
    Environment   = var.environment
    CostCenter    = var.cost_center
    ResourceOwner = "finops-lead@example.com"
  }
}
