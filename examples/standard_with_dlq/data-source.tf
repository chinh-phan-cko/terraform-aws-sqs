data "aws_secretsmanager_secret" "datadog_api_key" {
  provider = aws.mgmt
  name     = "datadog_api"
}

data "aws_secretsmanager_secret_version" "datadog_api_key_value" {
  provider  = aws.mgmt
  secret_id = data.aws_secretsmanager_secret.datadog_api_key.id
}

data "aws_secretsmanager_secret" "datadog_app_key" {
  provider = aws.mgmt
  name     = "techfinance/datadog-app"
}

data "aws_secretsmanager_secret_version" "datadog_app_key_value" {
  provider  = aws.mgmt
  secret_id = data.aws_secretsmanager_secret.datadog_app_key.id
}

data "aws_kms_alias" "kms_sqs" {
  name = "alias/finlab/sqs"
}
