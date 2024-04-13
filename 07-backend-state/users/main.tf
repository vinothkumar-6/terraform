variable "application_name" {
  default = "01-backend-state"
}

variable "project_name" {
  default = "users"
}

variable "environment" {
  default = "dev"
}

terraform {
  backend "s3" {
    bucket = "application-name-backend-state-vinoth"
  #  key            = "${var.application_name}-${var.project_name}-${var.environment}"
  key            = "application_name-project_name-environment"
    region         = "us-east-1"
    dynamodb_table = "dev_application_locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_vinoth"
}
