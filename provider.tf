terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.6"
}

# Configure the AWS Provider
# Supporting one region for now. TODO: check if we can generalize
provider "aws" {
  alias  = "aws-main-region"
  region = var.deployment_regions_list[0]
}
