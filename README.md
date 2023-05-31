# SQS Module

This module makes it easy to deploy an SQS queue.

This module creates:

- SQS queue
- SQS dead letter queue
- Redrive Policy
- Default SendMessages & ReceiveMessages Policy 

## Terraform versions

Terraform >= 0.13.5

## Usage

```hcl
module "<MODULE>" {
  source   = "github.com/cko-tech-finance/terraform-aws-sqs.git?ref=4.9.1"
}
```

## Examples

- [Standard Queue](/examples/standard_with_dlq/main.tf)
- [Standard Queue with SNS Subscription](/examples/standard_with_dlq_with_topic_subscription/main.tf)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.receive_messages_dead_letter_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.receive_messages_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.send_messages_dead_letter_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.send_messages_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_sqs_queue.dead_letter_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [datadog_monitor.dlq_latency](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.high_message_count](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.messages_in_dlq](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.new_messages](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.new_messages_in_dlq](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.no_message_alert](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [datadog_monitor.queue_high_latency](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/monitor) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.read_messages_dead_letter_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read_messages_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.send_messages_dead_letter_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.send_messages_default_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.read_access_dead_letter_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.read_access_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.redrive_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.write_access_dead_letter_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.write_access_policy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_high_latency_in_deadletter_queue_critical_threshold"></a> [alert\_high\_latency\_in\_deadletter\_queue\_critical\_threshold](#input\_alert\_high\_latency\_in\_deadletter\_queue\_critical\_threshold) | The monitor CRITICAL recovery threshold for old messages in dlq. | `number` | `1800` | no |
| <a name="input_alert_high_latency_in_deadletter_queue_description"></a> [alert\_high\_latency\_in\_deadletter\_queue\_description](#input\_alert\_high\_latency\_in\_deadletter\_queue\_description) | Description of the alert | `string` | `"A message in the deadletter queue has not been processed for a few days"` | no |
| <a name="input_alert_high_latency_in_deadletter_queue_enabled"></a> [alert\_high\_latency\_in\_deadletter\_queue\_enabled](#input\_alert\_high\_latency\_in\_deadletter\_queue\_enabled) | Whether or not to enable monitoring for old messages in dlq | `bool` | `false` | no |
| <a name="input_alert_high_latency_in_deadletter_queue_time_period"></a> [alert\_high\_latency\_in\_deadletter\_queue\_time\_period](#input\_alert\_high\_latency\_in\_deadletter\_queue\_time\_period) | The datadog evaluation period. For cloudwatch derived metrics, use a period >= last\_30m | `string` | `"last_30m"` | no |
| <a name="input_alert_high_latency_in_deadletter_runbook_link"></a> [alert\_high\_latency\_in\_deadletter\_runbook\_link](#input\_alert\_high\_latency\_in\_deadletter\_runbook\_link) | A link to the specific runbook page | `string` | `"**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"` | no |
| <a name="input_alert_high_latency_in_queue_critical_recovery_threshold"></a> [alert\_high\_latency\_in\_queue\_critical\_recovery\_threshold](#input\_alert\_high\_latency\_in\_queue\_critical\_recovery\_threshold) | The monitor CRITICAL recovery threshold for the high-latency alert. | `number` | `null` | no |
| <a name="input_alert_high_latency_in_queue_critical_threshold"></a> [alert\_high\_latency\_in\_queue\_critical\_threshold](#input\_alert\_high\_latency\_in\_queue\_critical\_threshold) | The monitor CRITICAL recovery threshold for the high-latency alert. | `number` | `1800` | no |
| <a name="input_alert_high_latency_in_queue_description"></a> [alert\_high\_latency\_in\_queue\_description](#input\_alert\_high\_latency\_in\_queue\_description) | Description of the alert | `string` | `"A healthy application should be continuing to process messages without much latency. A high latency on the queue indicates the application is not processing fast enough, or not at all. This should be investigated."` | no |
| <a name="input_alert_high_latency_in_queue_enabled"></a> [alert\_high\_latency\_in\_queue\_enabled](#input\_alert\_high\_latency\_in\_queue\_enabled) | Whether or not to enable the alert for a high latency in the primary queue | `bool` | `true` | no |
| <a name="input_alert_high_latency_in_queue_runbook_link"></a> [alert\_high\_latency\_in\_queue\_runbook\_link](#input\_alert\_high\_latency\_in\_queue\_runbook\_link) | A link to the specific runbook page | `string` | `"**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"` | no |
| <a name="input_alert_high_latency_in_queue_time_period"></a> [alert\_high\_latency\_in\_queue\_time\_period](#input\_alert\_high\_latency\_in\_queue\_time\_period) | The datadog evaluation period. For cloudwatch derived metrics, use a period >= last\_30m | `string` | `"last_30m"` | no |
| <a name="input_alert_high_latency_in_queue_warning_recovery_threshold"></a> [alert\_high\_latency\_in\_queue\_warning\_recovery\_threshold](#input\_alert\_high\_latency\_in\_queue\_warning\_recovery\_threshold) | The monitor WARNING recovery threshold for the high-latency alert. | `number` | `null` | no |
| <a name="input_alert_high_latency_in_queue_warning_threshold"></a> [alert\_high\_latency\_in\_queue\_warning\_threshold](#input\_alert\_high\_latency\_in\_queue\_warning\_threshold) | The monitor WARNING threshold for the high-latency alert. | `number` | `900` | no |
| <a name="input_alert_high_number_messages_in_queue_critical_recovery_threshold"></a> [alert\_high\_number\_messages\_in\_queue\_critical\_recovery\_threshold](#input\_alert\_high\_number\_messages\_in\_queue\_critical\_recovery\_threshold) | The monitor CRITICAL recovery threshold for the high-message-count alert. | `number` | `null` | no |
| <a name="input_alert_high_number_messages_in_queue_critical_threshold"></a> [alert\_high\_number\_messages\_in\_queue\_critical\_threshold](#input\_alert\_high\_number\_messages\_in\_queue\_critical\_threshold) | The monitor CRITICAL threshold for the high-message-count alert. | `number` | `1000` | no |
| <a name="input_alert_high_number_messages_in_queue_description"></a> [alert\_high\_number\_messages\_in\_queue\_description](#input\_alert\_high\_number\_messages\_in\_queue\_description) | Description of the alert | `string` | `"A healthy application should be continuing to process messages without much latency. A high latency on the queue indicates the application is not processing fast enough, or not at all. This should be investigated."` | no |
| <a name="input_alert_high_number_messages_in_queue_enabled"></a> [alert\_high\_number\_messages\_in\_queue\_enabled](#input\_alert\_high\_number\_messages\_in\_queue\_enabled) | Whether or not to enable the alert for a large number of pending messages on a queue | `bool` | `true` | no |
| <a name="input_alert_high_number_messages_in_queue_runbook_link"></a> [alert\_high\_number\_messages\_in\_queue\_runbook\_link](#input\_alert\_high\_number\_messages\_in\_queue\_runbook\_link) | A link to the specific runbook page | `string` | `"**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"` | no |
| <a name="input_alert_high_number_messages_in_queue_time_period"></a> [alert\_high\_number\_messages\_in\_queue\_time\_period](#input\_alert\_high\_number\_messages\_in\_queue\_time\_period) | The datadog evaluation period. For cloudwatch derived metrics, use a period >= last\_30m | `string` | `"last_30m"` | no |
| <a name="input_alert_high_number_messages_in_queue_warning_recovery_threshold"></a> [alert\_high\_number\_messages\_in\_queue\_warning\_recovery\_threshold](#input\_alert\_high\_number\_messages\_in\_queue\_warning\_recovery\_threshold) | The monitor WARNING recovery threshold for the high-message-count alert. | `number` | `null` | no |
| <a name="input_alert_high_number_messages_in_queue_warning_threshold"></a> [alert\_high\_number\_messages\_in\_queue\_warning\_threshold](#input\_alert\_high\_number\_messages\_in\_queue\_warning\_threshold) | The monitor WARNING threshold for the high-message-count alert. | `number` | `750` | no |
| <a name="input_alert_messages_in_deadletter_queue_critical_threshold"></a> [alert\_messages\_in\_deadletter\_queue\_critical\_threshold](#input\_alert\_messages\_in\_deadletter\_queue\_critical\_threshold) | The monitor CRITICAL threshold for the dlq alert. | `number` | `0` | no |
| <a name="input_alert_messages_in_deadletter_queue_description"></a> [alert\_messages\_in\_deadletter\_queue\_description](#input\_alert\_messages\_in\_deadletter\_queue\_description) | Description of the alert | `string` | `"Messages should only ever appear on a deadletter queue when the application is having trouble processing. Occassionally, we may temporarily park messages and revisit them later after an application issue has been resolved."` | no |
| <a name="input_alert_messages_in_deadletter_queue_enabled"></a> [alert\_messages\_in\_deadletter\_queue\_enabled](#input\_alert\_messages\_in\_deadletter\_queue\_enabled) | Whether or not to enable the alert for a large number of pending messages on a deadletter queue | `bool` | `true` | no |
| <a name="input_alert_messages_in_deadletter_queue_runbook_link"></a> [alert\_messages\_in\_deadletter\_queue\_runbook\_link](#input\_alert\_messages\_in\_deadletter\_queue\_runbook\_link) | A link to the specific runbook page | `string` | `"**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"` | no |
| <a name="input_alert_messages_in_deadletter_queue_time_period"></a> [alert\_messages\_in\_deadletter\_queue\_time\_period](#input\_alert\_messages\_in\_deadletter\_queue\_time\_period) | The datadog evaluation period. For cloudwatch derived metrics, use a period >= last\_30m | `string` | `"last_30m"` | no |
| <a name="input_alert_new_messages_in_deadletter_queue_critical_threshold"></a> [alert\_new\_messages\_in\_deadletter\_queue\_critical\_threshold](#input\_alert\_new\_messages\_in\_deadletter\_queue\_critical\_threshold) | The monitor CRITICAL threshold for the dlq alert. | `number` | `0` | no |
| <a name="input_alert_new_messages_in_deadletter_queue_description"></a> [alert\_new\_messages\_in\_deadletter\_queue\_description](#input\_alert\_new\_messages\_in\_deadletter\_queue\_description) | Description of the alert | `string` | `"Messages should only ever appear on a deadletter queue when the application is having trouble processing."` | no |
| <a name="input_alert_new_messages_in_deadletter_queue_enabled"></a> [alert\_new\_messages\_in\_deadletter\_queue\_enabled](#input\_alert\_new\_messages\_in\_deadletter\_queue\_enabled) | Whether or not to enable the alert for a new number of pending messages on a deadletter queue | `bool` | `false` | no |
| <a name="input_alert_new_messages_in_deadletter_queue_runbook_link"></a> [alert\_new\_messages\_in\_deadletter\_queue\_runbook\_link](#input\_alert\_new\_messages\_in\_deadletter\_queue\_runbook\_link) | A link to the specific runbook page | `string` | `"**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"` | no |
| <a name="input_alert_new_messages_in_deadletter_queue_time_period"></a> [alert\_new\_messages\_in\_deadletter\_queue\_time\_period](#input\_alert\_new\_messages\_in\_deadletter\_queue\_time\_period) | The datadog evaluation period. For cloudwatch derived metrics, use a period >= last\_30m | `string` | `"last_30m"` | no |
| <a name="input_alert_new_messages_in_deadletter_queue_timeshift_in_seconds"></a> [alert\_new\_messages\_in\_deadletter\_queue\_timeshift\_in\_seconds](#input\_alert\_new\_messages\_in\_deadletter\_queue\_timeshift\_in\_seconds) | The number of seconds ago to compare that a new message came in | `number` | `300` | no |
| <a name="input_alert_new_messages_in_queue_critical_threshold"></a> [alert\_new\_messages\_in\_queue\_critical\_threshold](#input\_alert\_new\_messages\_in\_queue\_critical\_threshold) | The monitor CRITICAL threshold for the alert. | `number` | `0` | no |
| <a name="input_alert_new_messages_in_queue_description"></a> [alert\_new\_messages\_in\_queue\_description](#input\_alert\_new\_messages\_in\_queue\_description) | Description of the alert | `string` | `"A healthy application should be continuing to process messages at the rate they come in."` | no |
| <a name="input_alert_new_messages_in_queue_enabled"></a> [alert\_new\_messages\_in\_queue\_enabled](#input\_alert\_new\_messages\_in\_queue\_enabled) | Whether or not to enable the alert for a new number of pending messages on the primary queue | `bool` | `false` | no |
| <a name="input_alert_new_messages_in_queue_runbook_link"></a> [alert\_new\_messages\_in\_queue\_runbook\_link](#input\_alert\_new\_messages\_in\_queue\_runbook\_link) | A link to the specific runbook page | `string` | `"**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"` | no |
| <a name="input_alert_new_messages_in_queue_time_period"></a> [alert\_new\_messages\_in\_queue\_time\_period](#input\_alert\_new\_messages\_in\_queue\_time\_period) | The datadog evaluation period. For cloudwatch derived metrics, use a period >= last\_30m | `string` | `"last_30m"` | no |
| <a name="input_alert_new_messages_in_queue_timeshift_in_seconds"></a> [alert\_new\_messages\_in\_queue\_timeshift\_in\_seconds](#input\_alert\_new\_messages\_in\_queue\_timeshift\_in\_seconds) | The number of seconds ago to compare that a new message came in | `number` | `300` | no |
| <a name="input_alert_no_message_in_queue_description"></a> [alert\_no\_message\_in\_queue\_description](#input\_alert\_no\_message\_in\_queue\_description) | Description of the alert | `string` | `"No Message received in allotted time period please investigate"` | no |
| <a name="input_alert_number_of_no_messages_monitor_threshold"></a> [alert\_number\_of\_no\_messages\_monitor\_threshold](#input\_alert\_number\_of\_no\_messages\_monitor\_threshold) | The monitor CRITICAL threshold for no message received | `number` | `1` | no |
| <a name="input_content_based_deduplication"></a> [content\_based\_deduplication](#input\_content\_based\_deduplication) | Set to true to enable content-based deduplication for FIFO queues. | `bool` | `false` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | A map of custom tags to apply to the queues. The key is the tag name and the value is the tag value. | `map(string)` | `{}` | no |
| <a name="input_dead_letter_queue"></a> [dead\_letter\_queue](#input\_dead\_letter\_queue) | Set to true to enable a dead letter queue. Messages that cannot be processed/consumed successfully will be sent to a second queue so you can set aside these messages and analyze what went wrong. | `bool` | `true` | no |
| <a name="input_dead_letter_queue_name"></a> [dead\_letter\_queue\_name](#input\_dead\_letter\_queue\_name) | Custom name of the dead letter queue. Note that this module may append '.fifo' to this name depending on the value of var.fifo\_queue. | `string` | `null` | no |
| <a name="input_deduplication_scope"></a> [deduplication\_scope](#input\_deduplication\_scope) | Specifies whether message deduplication occurs at the message group or queue level. Valid values are 'messageGroup' and 'queue'. | `string` | `null` | no |
| <a name="input_delay_seconds"></a> [delay\_seconds](#input\_delay\_seconds) | The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes). | `number` | `0` | no |
| <a name="input_dlq_custom_tags"></a> [dlq\_custom\_tags](#input\_dlq\_custom\_tags) | A map of custom tags to apply to the dead letter queue ONLY. The key is the tag name and the value is the tag value. | `map(string)` | `{}` | no |
| <a name="input_dlq_message_retention_seconds"></a> [dlq\_message\_retention\_seconds](#input\_dlq\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message in the dead letter queue. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). | `number` | `345600` | no |
| <a name="input_enable_redrive_policy_on_dlq"></a> [enable\_redrive\_policy\_on\_dlq](#input\_enable\_redrive\_policy\_on\_dlq) | Enable redrive policy on DLQ | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment that we are creating the queue in | `string` | n/a | yes |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | Set to true to make this a FIFO queue. | `bool` | `false` | no |
| <a name="input_fifo_throughput_limit"></a> [fifo\_throughput\_limit](#input\_fifo\_throughput\_limit) | Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. Valid values are 'perQueue' and 'perMessageGroupId'. | `string` | `null` | no |
| <a name="input_kms_data_key_reuse_period_seconds"></a> [kms\_data\_key\_reuse\_period\_seconds](#input\_kms\_data\_key\_reuse\_period\_seconds) | The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours) | `number` | `300` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | Key Id for encryption in transit | `any` | n/a | yes |
| <a name="input_max_message_size"></a> [max\_message\_size](#input\_max\_message\_size) | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB). | `number` | `262144` | no |
| <a name="input_max_receive_count"></a> [max\_receive\_count](#input\_max\_receive\_count) | The maximum number of times that a message can be received by consumers. When this value is exceeded for a message the message will be automatically sent to the Dead Letter Queue. Only used if var.dead\_letter\_queue is true. | `number` | `5` | no |
| <a name="input_message_retention_seconds"></a> [message\_retention\_seconds](#input\_message\_retention\_seconds) | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). | `number` | `345600` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the queue. Note that this module may append '.fifo' to this name depending on the value of var.fifo\_queue. | `string` | n/a | yes |
| <a name="input_no_message_alert_enabled"></a> [no\_message\_alert\_enabled](#input\_no\_message\_alert\_enabled) | Whether to enable the monitor to alert when no messages are received in a SQSS queue | `bool` | `false` | no |
| <a name="input_no_message_alert_enabled_time_period"></a> [no\_message\_alert\_enabled\_time\_period](#input\_no\_message\_alert\_enabled\_time\_period) | he datadog evaluation period. For cloudwatch derived metrics, use a period >= last\_30m | `string` | `"last_30m"` | no |
| <a name="input_no_message_recieved_in_queue_runbook_link"></a> [no\_message\_recieved\_in\_queue\_runbook\_link](#input\_no\_message\_recieved\_in\_queue\_runbook\_link) | A link to the specific runbook page | `string` | `"**NOT SUPPLIED CONTACT TEAM FOR REMEDIATION INSTRUCTIONS**"` | no |
| <a name="input_notification_channel_override"></a> [notification\_channel\_override](#input\_notification\_channel\_override) | Allows the override of the Slack notification channel for Datadog alerting | `string` | `""` | no |
| <a name="input_primary_queue_custom_tags"></a> [primary\_queue\_custom\_tags](#input\_primary\_queue\_custom\_tags) | A map of custom tags to apply to the primary letter queue ONLY. The key is the tag name and the value is the tag value. | `map(string)` | `{}` | no |
| <a name="input_product"></a> [product](#input\_product) | Product name | `string` | n/a | yes |
| <a name="input_receive_wait_time_seconds"></a> [receive\_wait\_time\_seconds](#input\_receive\_wait\_time\_seconds) | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). Setting this to 0 means the call will return immediately. | `number` | `20` | no |
| <a name="input_renotify_alert_interval"></a> [renotify\_alert\_interval](#input\_renotify\_alert\_interval) | The number of minutes after the last notification before a monitor will re-notify on the current status. It will only re-notify if it's not resolved. | `number` | `0` | no |
| <a name="input_visibility_timeout_seconds"></a> [visibility\_timeout\_seconds](#input\_visibility\_timeout\_seconds) | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours). | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dead_letter_queue_arn"></a> [dead\_letter\_queue\_arn](#output\_dead\_letter\_queue\_arn) | n/a |
| <a name="output_dead_letter_queue_name"></a> [dead\_letter\_queue\_name](#output\_dead\_letter\_queue\_name) | n/a |
| <a name="output_dead_letter_queue_url"></a> [dead\_letter\_queue\_url](#output\_dead\_letter\_queue\_url) | n/a |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | n/a |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | n/a |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | n/a |
| <a name="output_read_access_dead_letter_policy_document"></a> [read\_access\_dead\_letter\_policy\_document](#output\_read\_access\_dead\_letter\_policy\_document) | n/a |
| <a name="output_read_access_policy_document"></a> [read\_access\_policy\_document](#output\_read\_access\_policy\_document) | n/a |
| <a name="output_receive_messages_dead_letter_default_policy_arn"></a> [receive\_messages\_dead\_letter\_default\_policy\_arn](#output\_receive\_messages\_dead\_letter\_default\_policy\_arn) | n/a |
| <a name="output_receive_messages_default_policy_arn"></a> [receive\_messages\_default\_policy\_arn](#output\_receive\_messages\_default\_policy\_arn) | n/a |
| <a name="output_send_messages_dead_letter_default_policy_arn"></a> [send\_messages\_dead\_letter\_default\_policy\_arn](#output\_send\_messages\_dead\_letter\_default\_policy\_arn) | n/a |
| <a name="output_send_messages_default_policy_arn"></a> [send\_messages\_default\_policy\_arn](#output\_send\_messages\_default\_policy\_arn) | n/a |
| <a name="output_write_access_dead_letter_policy_document"></a> [write\_access\_dead\_letter\_policy\_document](#output\_write\_access\_dead\_letter\_policy\_document) | n/a |
| <a name="output_write_access_policy_document"></a> [write\_access\_policy\_document](#output\_write\_access\_policy\_document) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
