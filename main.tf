terraform {
  backend "gcs" {
    bucket = "devops-secrets"
    prefix = "terraform/state/buckets"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.43.1"
    }
  }
}

provider "google" {
  region = "us-east4"
}
