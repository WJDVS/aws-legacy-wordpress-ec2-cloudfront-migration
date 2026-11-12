variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for deployment"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Target deployment environment"
}

variable "project_name" {
  type        = string
  default     = "legacy-wp"
  description = "Project component prefix"
}
