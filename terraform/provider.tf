terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = local.region
  shared_credentials_file = "%USERPROFILE%/.aws/credentials"
  profile                 = "terraformuser"
}