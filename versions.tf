terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    datadog = {
      source = "datadog/datadog"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
