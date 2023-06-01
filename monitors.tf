//======================================================================================
//    High latency for a message on the queue
//    This is a sign that the application is not processing at all, or falling behind quite a bit
//    This alert may trigger at the same time as the high number of pending messages below
//======================================================================================
resource "datadog_monitor" "queue_high_latency" {
  count   = var.alert_high_latency_in_queue_enabled ? 1 : 0
  name    = "[${var.product}] High latency on SQS queue '${aws_sqs_queue.queue.name}'"
  type    = "query alert"
  message = "## Link to Runbook\n${var.alert_high_latency_in_queue_runbook_link}\n\n## Description\n${var.alert_high_latency_in_queue_description}\n\n## Notifies\n@${local.notification_channel}"
  query   = "avg(${var.alert_high_latency_in_queue_time_period}):avg:aws.sqs.approximate_age_of_oldest_message{aws_account:${data.aws_caller_identity.current.account_id},queuename:${aws_sqs_queue.queue.name}} > ${var.alert_high_latency_in_queue_critical_threshold}"

  monitor_thresholds {
    critical          = var.alert_high_latency_in_queue_critical_threshold
    warning           = var.alert_high_latency_in_queue_warning_threshold
    warning_recovery  = var.alert_high_latency_in_queue_warning_recovery_threshold
    critical_recovery = var.alert_high_latency_in_queue_critical_recovery_threshold
  }

  require_full_window = false

  tags = concat(local.datadog_tags, ["high-latency"])
}

//======================================================================================
//    High number of pending messages on primary queue
//    This is a sign that the application cannot keep up with the volume of messages
//======================================================================================
resource "datadog_monitor" "high_message_count" {
  count   = var.alert_high_number_messages_in_queue_enabled ? 1 : 0
  name    = "[${var.product}] High pending message count on SQS queue '${aws_sqs_queue.queue.name}'"
  type    = "query alert"
  message = "## Link to Runbook\n${var.alert_high_number_messages_in_queue_runbook_link}\n\n## Description\n${var.alert_high_number_messages_in_queue_description}\n\n## Notifies\n@${local.notification_channel}"
  query   = "avg(${var.alert_high_number_messages_in_queue_time_period}):avg:aws.sqs.approximate_number_of_messages_visible{aws_account:${data.aws_caller_identity.current.account_id},queuename:${aws_sqs_queue.queue.name}} > ${var.alert_high_number_messages_in_queue_critical_threshold}"

  monitor_thresholds {
    critical          = var.alert_high_number_messages_in_queue_critical_threshold
    warning           = var.alert_high_number_messages_in_queue_warning_threshold
    warning_recovery  = var.alert_high_number_messages_in_queue_warning_recovery_threshold
    critical_recovery = var.alert_high_number_messages_in_queue_critical_recovery_threshold
  }

  require_full_window = false

  tags = concat(local.datadog_tags, ["high-message-count"])
}

//======================================================================================
//    Appearance of new messages in the primary queue
//    When the main queue is considered a DLQ this can be used in place of the new_messages_in_dlq monitor
//======================================================================================
resource "datadog_monitor" "new_messages" {
  count   = var.alert_new_messages_in_queue_enabled ? 1 : 0
  name    = "[${var.product}] New messages on SQS queue '${aws_sqs_queue.queue.name}'"
  type    = "query alert"
  message = "{{#is_alert}}## Link to Runbook\n${var.alert_new_messages_in_queue_runbook_link}\n\n## Description\n${var.alert_new_messages_in_queue_description}\n\n## Notifies\n@${local.notification_channel}{{/is_alert}}"
  query   = "max(${var.alert_new_messages_in_queue_time_period}):timeshift(max:aws.sqs.approximate_number_of_messages_visible{aws_account:${data.aws_caller_identity.current.account_id},queuename:${aws_sqs_queue.queue.name}}, ${var.alert_new_messages_in_queue_timeshift_in_seconds}) - default_zero(max:aws.sqs.approximate_number_of_messages_visible{aws_account:${data.aws_caller_identity.current.account_id},queuename:${aws_sqs_queue.queue.name}}) > ${var.alert_new_messages_in_queue_critical_threshold}"

  monitor_thresholds {
    critical = var.alert_new_messages_in_queue_critical_threshold
  }

  require_full_window = false

  tags = concat(local.datadog_tags, ["new-messages"])
}

//======================================================================================
//    Appearance of messages in the deadletter queue
//    This is a sign that there is no automated way of dealing with deadletter messages
//======================================================================================
resource "datadog_monitor" "messages_in_dlq" {
  count   = var.alert_messages_in_deadletter_queue_enabled && var.dead_letter_queue ? 1 : 0
  name    = "[${var.product}] Messages on SQS deadletter queue '${aws_sqs_queue.dead_letter_queue[0].name}'"
  type    = "query alert"
  message = "## Link to Runbook\n${var.alert_messages_in_deadletter_queue_runbook_link}\n\n## Description\n${var.alert_messages_in_deadletter_queue_description}\n\n## Notifies\n@${local.notification_channel}"
  query   = "avg(${var.alert_messages_in_deadletter_queue_time_period}):avg:aws.sqs.approximate_number_of_messages_visible{aws_account:${data.aws_caller_identity.current.account_id},queuename:${aws_sqs_queue.dead_letter_queue[0].name}} > ${var.alert_messages_in_deadletter_queue_critical_threshold}"

  monitor_thresholds {
    critical = var.alert_messages_in_deadletter_queue_critical_threshold
  }

  require_full_window = false
  renotify_interval   = var.renotify_alert_interval

  tags = concat(local.datadog_tags, ["dlq"])
}

//======================================================================================
//    Message has been in the dead letter queue for too long
//    This is a sign that some messages have not been processed for a long time
//======================================================================================
resource "datadog_monitor" "dlq_latency" {
  count   = var.alert_high_latency_in_deadletter_queue_enabled && var.dead_letter_queue ? 1 : 0
  name    = "[${var.product}]  High latency on SQS dead letter queue'${aws_sqs_queue.dead_letter_queue[0].name}'"
  type    = "query alert"
  message = "## Link to Runbook\n${var.alert_high_latency_in_deadletter_runbook_link}\n\n## Description\n${var.alert_high_latency_in_deadletter_queue_description}\n\n## Notifies\n@${local.notification_channel}"
  query   = "avg(${var.alert_high_latency_in_deadletter_queue_time_period}):avg:aws.sqs.approximate_age_of_oldest_message{aws_account:${data.aws_caller_identity.current.account_id},queuename:${aws_sqs_queue.dead_letter_queue[0].name}} > ${var.alert_high_latency_in_deadletter_queue_critical_threshold}"

  monitor_thresholds {
    critical = var.alert_high_latency_in_deadletter_queue_critical_threshold
  }

  require_full_window = false

  tags = concat(local.datadog_tags, ["high-latency"])
}

//======================================================================================
//    Appearance of new messages in the deadletter queue
//    This is a sign new messages have not been processed and has just entered dead letter queue
//======================================================================================
resource "datadog_monitor" "new_messages_in_dlq" {
  count   = var.alert_new_messages_in_deadletter_queue_enabled && var.dead_letter_queue ? 1 : 0
  name    = "[${var.product}] New messages on SQS deadletter queue '${aws_sqs_queue.dead_letter_queue[0].name}'"
  type    = "query alert"
  message = "{{#is_alert}}## Link to Runbook\n${var.alert_new_messages_in_deadletter_queue_runbook_link}\n\n## Description\n${var.alert_new_messages_in_deadletter_queue_description}\n\n## Notifies\n@${local.notification_channel}{{/is_alert}}"
  query   = "max(${var.alert_new_messages_in_deadletter_queue_time_period}):timeshift(max:aws.sqs.approximate_number_of_messages_visible{aws_account:${data.aws_caller_identity.current.account_id},queuename:${aws_sqs_queue.dead_letter_queue[0].name}}, ${var.alert_new_messages_in_deadletter_queue_timeshift_in_seconds}) - default_zero(max:aws.sqs.approximate_number_of_messages_visible{aws_account:${data.aws_caller_identity.current.account_id},queuename:${aws_sqs_queue.dead_letter_queue[0].name}}) > ${var.alert_new_messages_in_deadletter_queue_critical_threshold}"

  monitor_thresholds {
    critical = var.alert_new_messages_in_deadletter_queue_critical_threshold
  }

  require_full_window = false

  tags = concat(local.datadog_tags, ["new-messages", "dlq"])
}

//======================================================================================
//    Create an alert for a given SQS queue if a they do not receive any activity
//    for a given period of time
//======================================================================================
resource "datadog_monitor" "no_message_alert" {
  count   = var.no_message_alert_enabled ? 1 : 0
  name    = "[${var.product}]-no-received-messages-${aws_sqs_queue.queue.name}"
  type    = "query alert"
  message = "## Link to Runbook\n${var.no_message_recieved_in_queue_runbook_link}\n\n## Description\n${var.alert_no_message_in_queue_description}\n\n## Notifies\n@${local.notification_channel}"
  query   = "sum(${var.no_message_alert_enabled_time_period}):avg:aws.sqs.number_of_messages_received{name:${aws_sqs_queue.queue.name}}.as_count() < ${var.alert_number_of_no_messages_monitor_threshold}"

  monitor_thresholds {
    critical = var.alert_number_of_no_messages_monitor_threshold
  }
  tags = concat(local.datadog_tags, ["no-sqs-messages"])
}
