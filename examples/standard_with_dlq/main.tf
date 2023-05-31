module "standard" {
  source                                                = "../.."
  count                                                 = var.create_queue ? 1 : 0
  name                                                  = "${var.product}-standard-queue-${terraform.workspace}"
  product                                               = var.product
  custom_tags                                           = local.tags
  kms_master_key_id                                     = data.aws_kms_alias.kms_sqs.target_key_arn
  environment                                           = terraform.workspace
  delay_seconds                                         = var.sqs_delay_seconds
  message_retention_seconds                             = var.sqs_retention_seconds
  visibility_timeout_seconds                            = var.sqs_visibility_timeout_seconds
  max_receive_count                                     = var.sqs_dlq_max_receive_count
  notification_channel_override                         = local.datadog_slack_notification_channel_mbc
  alert_messages_in_deadletter_queue_enabled            = var.sqs_dlq_messages_alert_enabled
  alert_messages_in_deadletter_queue_runbook_link       = var.sqs_dlq_messages_runbook_link
  alert_messages_in_deadletter_queue_critical_threshold = var.sqs_dlq_messages_critical_threshold
  enable_redrive_policy_on_dlq                          = true
}

