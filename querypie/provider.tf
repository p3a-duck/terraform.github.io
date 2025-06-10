provider "aws" {
  region = var.region_apse1
}

terraform {
  required_version = ">= 1.5.7"
  required_providers {
   aws = {
    source = "hashicorp/aws"
    version = ">=5.0.0"
  }
 }
}

