terraform {
  required_version = ">= 0.13.1"

  required_providers {

    alkira = {
      source  = "alkiranet/alkira"
      version = ">= 0.8.1"
    }

    oci = {
      source  = "hashicorp/oci"
      version = ">=4.41.0"
    }

  }
}
