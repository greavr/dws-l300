terraform {
  required_version = ">= 1.1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.34.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "~> 6.34.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }      
  }
}
