
locals {
  notification_channel = var.notification_channel_override != "" ? var.notification_channel_override : "slack-techfinance-${var.product}-${var.environment}-alerts"
  alert_notification_channels = var.alert_notification_channels != [] ? "{{#is_alert}} ${join("\n", formatlist("@%s", var.alert_notification_channels))}{{/is_alert}}" : ""
  alert_recovery_notification_channels = var.alert_recovery_notification_channels != [] ? "{{#is_alert_recovery}} ${join("\n", formatlist("@%s", var.alert_recovery_notification_channels))}{{/is_alert_recovery}}" : "" 
  datadog_tags = [
    "terraform",
    "techfinance",
    "sqs",
    var.product,
    var.environment
  ]
  main_queue_name     = "${var.name}${var.fifo_queue ? ".fifo" : ""}"
  main_queue_fullname = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.main_queue_name}"
  dl_queue_name       = var.dead_letter_queue_name != null ? "${var.dead_letter_queue_name}${var.fifo_queue ? ".fifo" : ""}" : "${var.name}-dead-letter${var.fifo_queue ? ".fifo" : ""}"
}
