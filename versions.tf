terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.80.0"
      # https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/latest?tab=dependencies
    }
  }
}
