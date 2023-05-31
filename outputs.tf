output "queue_name" {
  value = aws_sqs_queue.queue.name
}

output "queue_url" {
  value = aws_sqs_queue.queue.id
}

output "queue_arn" {
  value = aws_sqs_queue.queue.arn
}

output "dead_letter_queue_name" {
  value = element(concat(aws_sqs_queue.dead_letter_queue.*.name, [""]), 0)
}

output "dead_letter_queue_url" {
  value = element(concat(aws_sqs_queue.dead_letter_queue.*.id, [""]), 0)
}

output "dead_letter_queue_arn" {
  value = element(concat(aws_sqs_queue.dead_letter_queue.*.arn, [""]), 0)
}

output "send_messages_default_policy_arn" {
  value = aws_iam_policy.send_messages_default_policy.arn
}

output "receive_messages_default_policy_arn" {
  value = aws_iam_policy.receive_messages_default_policy.arn
}

output "read_access_policy_document" {
  value = data.template_file.read_access_policy.rendered
}

output "write_access_policy_document" {
  value = data.template_file.write_access_policy.rendered
}

output "send_messages_dead_letter_default_policy_arn" {
  value = element(concat(aws_iam_policy.send_messages_dead_letter_default_policy.*.arn, [""]), 0)
}

output "receive_messages_dead_letter_default_policy_arn" {
  value = element(concat(aws_iam_policy.receive_messages_dead_letter_default_policy.*.arn, [""]), 0)
}

output "read_access_dead_letter_policy_document" {
  value = element(concat(data.template_file.read_access_dead_letter_policy.*.rendered, [""]), 0)
}

output "write_access_dead_letter_policy_document" {
  value = element(concat(data.template_file.write_access_dead_letter_policy.*.rendered, [""]), 0)
}