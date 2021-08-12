locals {
  region = var.aws_region
  ecr_defaults = {
    repository_name = "app-registry"
  }
  ecr = merge(local.ecr_defaults, var.ecr_values)
}