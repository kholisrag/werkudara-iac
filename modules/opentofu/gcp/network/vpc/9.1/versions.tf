terraform {
  required_version = ">= 1.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.34"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.34"
    }
  }
}
