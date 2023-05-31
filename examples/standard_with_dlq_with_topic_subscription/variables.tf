variable "product" {
  description = "Product"
  default     = "finlab"
}

variable "account_id" {
  description = "Account ID"
  default     = "851429951072"
}

variable "create_queue" {
  default     = true
  description = "Enable the creation of the queue"
}

variable "create_topic" {
  default     = true
  description = "Enable the creation of the queue"
}

variable "sqs_delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed."
  default     = 0
  type        = number
}

variable "sqs_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)."
  default     = 1209600
  type        = number
}

variable "sqs_visibility_timeout_seconds" {
  description = "The number of seconds for the visibility timeout for the queue. An integer from 0 to 43200 (12 hours)."
  default     = 60
}

variable "sqs_dlq_max_receive_count" {
  description = "The number of times that a message can be received before being sent to the dead-letter queue. Value between 1 and 1,000"
  default     = 1
}

variable "sqs_dlq_messages_alert_enabled" {
  description = "Whether average number of messages on dead letter queue alert is enabled"
  default     = true
}

variable "sqs_dlq_messages_critical_threshold" {
  description = "The average number of messages to have in the dead letter queue during the evaluation window"
  default     = 1
}

variable "sqs_dlq_messages_runbook_link" {
  description = "Link to runbook for dead letter queue"
  default     = "https://checkout.atlassian.net/wiki/spaces/NOC/pages/RunBookId"
}