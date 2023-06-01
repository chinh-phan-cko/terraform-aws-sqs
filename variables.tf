variable "name" {
  description = "The name of the queue. Note that this module may append '.fifo' to this name depending on the value of var.fifo_queue."
  type        = string
}

variable "environment" {
  description = "The environment that we are creating the queue in"
  type        = string
}

variable "product" {
  description = "Product name"
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)."
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)."
  type        = number
  default     = 345600
  # 4 days
}

variable "dlq_message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message in the dead letter queue. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)."
  type        = number
  default     = 345600
  # 4 days
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)."
  type        = number
  default     = 262144
  # 256 KiB
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)."
  type        = number
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). Setting this to 0 means the call will return immediately."
  type        = number
  default     = 20
}

variable "fifo_queue" {
  description = "Set to true to make this a FIFO queue."
  type        = bool
  default     = false
}

variable "fifo_throughput_limit" {
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. Valid values are 'perQueue' and 'perMessageGroupId'."
  type        = string
  default     = null
}

variable "content_based_deduplication" {
  description = "Set to true to enable content-based deduplication for FIFO queues."
  type        = bool
  default     = false
}

variable "deduplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level. Valid values are 'messageGroup' and 'queue'."
  type        = string
  default     = null
}

variable "dead_letter_queue" {
  description = "Set to true to enable a dead letter queue. Messages that cannot be processed/consumed successfully will be sent to a second queue so you can set aside these messages and analyze what went wrong."
  type        = bool
  default     = true
}

variable "dead_letter_queue_name" {
  description = "Custom name of the dead letter queue. Note that this module may append '.fifo' to this name depending on the value of var.fifo_queue."
  type        = string
  default     = null
}

variable "max_receive_count" {
  description = "The maximum number of times that a message can be received by consumers. When this value is exceeded for a message the message will be automatically sent to the Dead Letter Queue. Only used if var.dead_letter_queue is true."
  type        = number
  default     = 5
}

variable "kms_data_key_reuse_period_seconds" {
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours)"
  type        = number
  default     = 300
}

variable "custom_tags" {
  description = "A map of custom tags to apply to the queues. The key is the tag name and the value is the tag value."
  type        = map(string)
  default     = {}
}

variable "dlq_custom_tags" {
  description = "A map of custom tags to apply to the dead letter queue ONLY. The key is the tag name and the value is the tag value."
  type        = map(string)
  default     = {}
}

variable "primary_queue_custom_tags" {
  description = "A map of custom tags to apply to the primary letter queue ONLY. The key is the tag name and the value is the tag value."
  type        = map(string)
  default     = {}
}

variable "kms_master_key_id" {
  description = "Key Id for encryption in transit"
}

variable "notification_channel_override" {
  description = "Allows the override of the Slack notification channel for Datadog alerting"
  default     = ""
}

variable "enable_redrive_policy_on_dlq" {
  description = "Enable redrive policy on DLQ"
  default     = false
}

#=================================================================
# High latency alert
#=================================================================
variable "alert_high_latency_in_queue_enabled" {
  description = "Whether or not to enable the alert for a high latency in the primary queue"
  default     = true
}
variable "alert_high_latency_in_queue_time_period" {
  description = "The datadog evaluation period. For cloudwatch derived metrics, use a period >= last_30m"
  default     = "last_30m"
}
variable "alert_high_latency_in_queue_warning_threshold" {
  description = "The monitor WARNING threshold for the high-latency alert."
  default     = 900 #seconds
  type        = number
}
variable "alert_high_latency_in_queue_critical_threshold" {
  description = "The monitor CRITICAL recovery threshold for the high-latency alert."
  default     = 1800 #seconds
  type        = number
}
variable "alert_high_latency_in_queue_warning_recovery_threshold" {
  description = "The monitor WARNING recovery threshold for the high-latency alert."
  default     = null
  type        = number
}
variable "alert_high_latency_in_queue_critical_recovery_threshold" {
  description = "The monitor CRITICAL recovery threshold for the high-latency alert."
  default     = null
  type        = number
}
variable "alert_high_latency_in_queue_runbook_link" {
  description = "A link to the specific runbook page"
  default     = "**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"
}
variable "alert_high_latency_in_queue_description" {
  description = "Description of the alert"
  default     = "A healthy application should be continuing to process messages without much latency. A high latency on the queue indicates the application is not processing fast enough, or not at all. This should be investigated."
}

#=================================================================
# High number of messages in primary queue alert
#=================================================================
variable "alert_high_number_messages_in_queue_enabled" {
  description = "Whether or not to enable the alert for a large number of pending messages on a queue"
  default     = true
}
variable "alert_high_number_messages_in_queue_time_period" {
  description = "The datadog evaluation period. For cloudwatch derived metrics, use a period >= last_30m"
  default     = "last_30m"
}
variable "alert_high_number_messages_in_queue_warning_threshold" {
  description = "The monitor WARNING threshold for the high-message-count alert."
  default     = 750
  type        = number
}
variable "alert_high_number_messages_in_queue_critical_threshold" {
  description = "The monitor CRITICAL threshold for the high-message-count alert."
  default     = 1000
  type        = number
}
variable "alert_high_number_messages_in_queue_warning_recovery_threshold" {
  description = "The monitor WARNING recovery threshold for the high-message-count alert."
  default     = null
  type        = number
}
variable "alert_high_number_messages_in_queue_critical_recovery_threshold" {
  description = "The monitor CRITICAL recovery threshold for the high-message-count alert."
  default     = null
  type        = number
}
variable "alert_high_number_messages_in_queue_runbook_link" {
  description = "A link to the specific runbook page"
  default     = "**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"
}
variable "alert_high_number_messages_in_queue_description" {
  description = "Description of the alert"
  default     = "A healthy application should be continuing to process messages without much latency. A high latency on the queue indicates the application is not processing fast enough, or not at all. This should be investigated."
}

#=================================================================
# NEW messages in primary queue alert
#=================================================================
variable "alert_new_messages_in_queue_enabled" {
  description = "Whether or not to enable the alert for a new number of pending messages on the primary queue"
  default     = false
}

variable "alert_new_messages_in_queue_time_period" {
  description = "The datadog evaluation period. For cloudwatch derived metrics, use a period >= last_30m"
  default     = "last_30m"
}

variable "alert_new_messages_in_queue_critical_threshold" {
  description = "The monitor CRITICAL threshold for the alert."
  default     = 0
  type        = number
}

variable "alert_new_messages_in_queue_runbook_link" {
  description = "A link to the specific runbook page"
  default     = "**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"
}

variable "alert_new_messages_in_queue_description" {
  description = "Description of the alert"
  default     = "A healthy application should be continuing to process messages at the rate they come in."
}

variable "alert_new_messages_in_queue_timeshift_in_seconds" {
  description = "The number of seconds ago to compare that a new message came in"
  default     = 300
}

#=================================================================
# Messages in deadletter queue alert
#=================================================================
variable "alert_messages_in_deadletter_queue_enabled" {
  description = "Whether or not to enable the alert for a large number of pending messages on a deadletter queue"
  default     = true
}
variable "alert_messages_in_deadletter_queue_time_period" {
  description = "The datadog evaluation period. For cloudwatch derived metrics, use a period >= last_30m"
  default     = "last_30m"
}
variable "alert_messages_in_deadletter_queue_critical_threshold" {
  description = "The monitor CRITICAL threshold for the dlq alert."
  default     = 0
  type        = number
}
variable "alert_messages_in_deadletter_queue_runbook_link" {
  description = "A link to the specific runbook page"
  default     = "**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"
}
variable "alert_messages_in_deadletter_queue_description" {
  description = "Description of the alert"
  default     = "Messages should only ever appear on a deadletter queue when the application is having trouble processing. Occassionally, we may temporarily park messages and revisit them later after an application issue has been resolved."
}
variable "renotify_alert_interval" {
  description = "The number of minutes after the last notification before a monitor will re-notify on the current status. It will only re-notify if it's not resolved."
  default     = 0
}


#=================================================================
# OLD messages in dead letter queue alert
#=================================================================

variable "alert_high_latency_in_deadletter_runbook_link" {
  description = "A link to the specific runbook page"
  default     = "**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"
}
variable "alert_high_latency_in_deadletter_queue_description" {
  description = "Description of the alert"
  default     = "A message in the deadletter queue has not been processed for a few days"
}

variable "alert_high_latency_in_deadletter_queue_enabled" {
  description = "Whether or not to enable monitoring for old messages in dlq"
  default     = false
}

variable "alert_high_latency_in_deadletter_queue_critical_threshold" {
  description = "The monitor CRITICAL recovery threshold for old messages in dlq."
  type        = number
  default     = 1800 #seconds
}

variable "alert_high_latency_in_deadletter_queue_time_period" {
  description = "The datadog evaluation period. For cloudwatch derived metrics, use a period >= last_30m"
  default     = "last_30m"
}

#=================================================================
# NEW messages in dead letter queue alert
#=================================================================

variable "alert_new_messages_in_deadletter_queue_enabled" {
  description = "Whether or not to enable the alert for a new number of pending messages on a deadletter queue"
  default     = false
}

variable "alert_new_messages_in_deadletter_queue_time_period" {
  description = "The datadog evaluation period. For cloudwatch derived metrics, use a period >= last_30m"
  default     = "last_30m"
}

variable "alert_new_messages_in_deadletter_queue_critical_threshold" {
  description = "The monitor CRITICAL threshold for the dlq alert."
  default     = 0
  type        = number
}

variable "alert_new_messages_in_deadletter_queue_runbook_link" {
  description = "A link to the specific runbook page"
  default     = "**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"
}

variable "alert_new_messages_in_deadletter_queue_description" {
  description = "Description of the alert"
  default     = "Messages should only ever appear on a deadletter queue when the application is having trouble processing."
}

variable "alert_new_messages_in_deadletter_queue_timeshift_in_seconds" {
  description = "The number of seconds ago to compare that a new message came in"
  default     = 300
}

#=================================================================
# NO messages in SQS queue alert
#=================================================================
variable "no_message_alert_enabled" {
  description = "Whether to enable the monitor to alert when no messages are received in a SQSS queue"
  default     = false
}

variable "no_message_alert_enabled_time_period" {
  description = "he datadog evaluation period. For cloudwatch derived metrics, use a period >= last_30m"
  default     = "last_30m"
}
variable "no_message_recieved_in_queue_runbook_link" {
  description = "A link to the specific runbook page"
  default     = "**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"
}

variable "alert_no_message_in_queue_description" {
  description = "Description of the alert"
  default     = "No Message received in allotted time period please investigate"
}

variable "alert_number_of_no_messages_monitor_threshold" {
  description = "The monitor CRITICAL threshold for no message received"
  default     = 1
}
