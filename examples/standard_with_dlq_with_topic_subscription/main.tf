module "standard" {
  source                                                = "../.."
  count                                                 = var.create_queue ? 1 : 0
  name                                                  = "${var.product}-standard-queue-with-sub-${terraform.workspace}"
  product                                               = var.product
  custom_tags                                           = local.tags
  kms_master_key_id                                     = data.aws_kms_alias.kms_sqs.target_key_arn
  environment                                           = terraform.workspace
  delay_seconds                                         = var.sqs_delay_seconds
  message_retention_seconds                             = var.sqs_retention_seconds
  visibility_timeout_seconds                            = var.sqs_visibility_timeout_seconds
  max_receive_count                                     = var.sqs_dlq_max_receive_count
  notification_channel_override                         = local.datadog_slack_notification_channel_mbc
  fifo_queue                                            = false
  alert_messages_in_deadletter_queue_enabled            = var.sqs_dlq_messages_alert_enabled
  alert_messages_in_deadletter_queue_runbook_link       = var.sqs_dlq_messages_runbook_link
  alert_messages_in_deadletter_queue_critical_threshold = var.sqs_dlq_messages_critical_threshold
}

resource "aws_sns_topic_subscription" "sqs_subscription" {
  count                = var.create_topic && var.create_queue ? 1 : 0
  topic_arn            = module.topic_to_subscribe[0].topic_arn
  protocol             = "sqs"
  endpoint             = module.standard[0].queue_arn
  raw_message_delivery = true
}

data "aws_iam_policy_document" "sqs_sns_policy" {
  count = var.create_topic && var.create_queue ? 1 : 0
  statement {
    actions = ["sqs:SendMessage"]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [module.standard[0].queue_arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.topic_to_subscribe[0].topic_arn]
    }
  }
}

resource "aws_sqs_queue_policy" "sqs_sns_policy" {
  count     = var.create_topic && var.create_queue ? 1 : 0
  queue_url = module.standard[0].queue_url
  policy    = data.aws_iam_policy_document.sqs_sns_policy[0].json
}

# Example topic
module "topic_to_subscribe" {
  count                       = var.create_topic ? 1 : 0
  source                      = "github.com/cko-tech-finance/terraform-aws-sns?ref=3.4.0"
  name                        = "${var.product}-topic-example-${terraform.workspace}"
  environment                 = terraform.workspace
  product                     = var.product
  kms_master_key_id           = data.aws_kms_alias.kms_sns.target_key_arn
  custom_tags                 = local.tags
  enable_sns_monitor          = false
  fifo_topic                  = false
  content_based_deduplication = false
}



