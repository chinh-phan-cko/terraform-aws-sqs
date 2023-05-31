terraform {
  backend "s3" {}
}

provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/spacelift"
    session_name = "terraform"
  }
  region = "eu-west-1"
}

provider "aws" {
  alias  = "mgmt"
  region = "eu-west-1"
}

provider "datadog" {
  api_key = jsondecode(data.aws_secretsmanager_secret_version.datadog_api_key_value.secret_string)["key"]
  app_key = jsondecode(data.aws_secretsmanager_secret_version.datadog_app_key_value.secret_string)["key"]
}