resource "aws_sqs_queue" "queue" {
  name                              = local.main_queue_name
  fifo_queue                        = var.fifo_queue
  fifo_throughput_limit             = var.fifo_throughput_limit
  redrive_policy                    = join("", data.template_file.redrive_policy.*.rendered)
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.message_retention_seconds
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  max_message_size                  = var.max_message_size
  content_based_deduplication       = var.content_based_deduplication
  deduplication_scope               = var.deduplication_scope
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  tags = merge(var.custom_tags, var.primary_queue_custom_tags,
    {
      Application = "sqs"
      Name        = var.name
  })
  depends_on = [
    aws_sqs_queue.dead_letter_queue
  ]
}

resource "aws_sqs_queue" "dead_letter_queue" {
  count                             = var.dead_letter_queue ? 1 : 0
  name                              = local.dl_queue_name
  fifo_queue                        = var.fifo_queue
  fifo_throughput_limit             = var.fifo_throughput_limit
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  message_retention_seconds         = var.dlq_message_retention_seconds
  delay_seconds                     = var.delay_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  max_message_size                  = var.max_message_size
  content_based_deduplication       = var.content_based_deduplication
  deduplication_scope               = var.deduplication_scope
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  tags = merge(var.custom_tags, var.dlq_custom_tags,
    {
      Application = "sqs"
      Name        = var.name
  })

  # static src queue name to avoid circular reference https://github.com/hashicorp/terraform-provider-aws/issues/22577
  redrive_allow_policy = var.enable_redrive_policy_on_dlq ? jsonencode({ redrivePermission = "byQueue", sourceQueueArns = [local.main_queue_fullname] }) : null
}

data "template_file" "redrive_policy" {
  count    = var.dead_letter_queue ? 1 : 0
  template = file("${path.module}/policies/redrive-deadletter-policy.json")
  vars = {
    dead_letter_queue_arn = aws_sqs_queue.dead_letter_queue[0].arn
    max_receive_count     = var.max_receive_count
  }
}

data "aws_iam_policy_document" "read_messages_default_policy" {
  statement {
    sid = "AllowReceiveMessagesToQueue"
    actions = [
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:ReceiveMessage",
      "sqs:Get*",
      "sqs:List*"
    ]
    resources = [
      aws_sqs_queue.queue.arn
    ]
  }
  statement {
    sid = "AllowDecryptionMessages"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      var.kms_master_key_id
    ]
  }
}

resource "aws_iam_policy" "receive_messages_default_policy" {
  name        = "${local.main_queue_name}-sqs-receive-messages-default-policy"
  description = "Default permissions to receive messages from ${local.main_queue_name} queue"
  policy      = data.aws_iam_policy_document.read_messages_default_policy.json
}

data "aws_iam_policy_document" "send_messages_default_policy" {
  statement {
    sid = "AllowSendMessagesToQueue"
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
      aws_sqs_queue.queue.arn
    ]
  }
  statement {
    sid = "AllowEncryptionMessages"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
      "kms:Encrypt"
    ]
    resources = [
      var.kms_master_key_id
    ]
  }
}

resource "aws_iam_policy" "send_messages_default_policy" {
  name        = "${local.main_queue_name}-sqs-send-messages-default-policy"
  description = "Default permissions to send messages to ${local.main_queue_name} queue"
  policy      = data.aws_iam_policy_document.send_messages_default_policy.json
}

data "template_file" "read_access_policy" {
  template = file("${path.module}/policies/read_access_policy.json")
  vars = {
    sqs_arn = aws_sqs_queue.queue.arn
  }
}

data "template_file" "write_access_policy" {
  template = file("${path.module}/policies/write_access_policy.json")
  vars = {
    sqs_arn = aws_sqs_queue.queue.arn
  }
}

data "aws_iam_policy_document" "read_messages_dead_letter_default_policy" {
  count = var.dead_letter_queue ? 1 : 0
  statement {
    sid = "AllowReceiveMessagesToQueue"
    actions = [
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:ReceiveMessage",
      "sqs:Get*",
      "sqs:List*"
    ]
    resources = [
      aws_sqs_queue.dead_letter_queue[0].arn
    ]
  }
  statement {
    sid = "AllowDecryptionMessages"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      var.kms_master_key_id
    ]
  }
}

resource "aws_iam_policy" "receive_messages_dead_letter_default_policy" {
  count       = var.dead_letter_queue ? 1 : 0
  name        = "${aws_sqs_queue.dead_letter_queue[0].name}-sqs-receive-messages-default-policy"
  description = "Default permissions to receive messages from ${aws_sqs_queue.dead_letter_queue[0].name} queue"
  policy      = data.aws_iam_policy_document.read_messages_dead_letter_default_policy[0].json
}

data "aws_iam_policy_document" "send_messages_dead_letter_default_policy" {
  count = var.dead_letter_queue ? 1 : 0
  statement {
    sid = "AllowSendMessagesToQueue"
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
      aws_sqs_queue.dead_letter_queue[0].arn
    ]
  }
  statement {
    sid = "AllowEncryptionMessages"
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
      "kms:Encrypt"
    ]
    resources = [
      var.kms_master_key_id
    ]
  }
}

resource "aws_iam_policy" "send_messages_dead_letter_default_policy" {
  count       = var.dead_letter_queue ? 1 : 0
  name        = "${aws_sqs_queue.dead_letter_queue[0].name}-sqs-send-messages-default-policy"
  description = "Default permissions to send messages to ${aws_sqs_queue.dead_letter_queue[0].name} queue"
  policy      = data.aws_iam_policy_document.send_messages_dead_letter_default_policy[0].json
}

data "template_file" "read_access_dead_letter_policy" {
  count    = var.dead_letter_queue ? 1 : 0
  template = file("${path.module}/policies/read_access_policy.json")
  vars = {
    sqs_arn = aws_sqs_queue.dead_letter_queue[0].arn
  }
}

data "template_file" "write_access_dead_letter_policy" {
  count    = var.dead_letter_queue ? 1 : 0
  template = file("${path.module}/policies/write_access_policy.json")
  vars = {
    sqs_arn = aws_sqs_queue.dead_letter_queue[0].arn
  }
}