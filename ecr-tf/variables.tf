variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "ecr_values" {
  type        = any
  default     = {}
  description = "AWS ECR configuration"
}


variable "availability_zone" {
  description = "availability zone to create subnet"
  type = list
  default = ["us-east-1a","us-east-1b","us-east-1c"]
}
