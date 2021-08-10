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

variable "ecs_values" {
  type        = any
  default     = {}
  description = "AWS ECS configuration"
}

variable "lb_values" {
  type        = any
  default     = {}
  description = "AWS Load Balancer configuration"
}

variable "vpc_values" {
  type        = any
  default     = {}
  description = "AWS Load Balancer configuration"
}

variable "container" {
  type        = any
  default     = {}
  description = "Container configuration to deploy"
}

variable "health_check_path" {
  default = "/"
}

variable "availability_zone" {
  description = "availability zone to create subnet"
  type = list
  default = ["us-east-1a","us-east-1b","us-east-1c"]
}
