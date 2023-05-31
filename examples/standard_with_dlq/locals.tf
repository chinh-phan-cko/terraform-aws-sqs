locals {
  tags = {
    "Product-Group" : "Tech Finance"
    "Product" : "cko-fts",
    "Team" : "fts",
    "Environment" : terraform.workspace
  }
  datadog_slack_notification_channel_mbc = "slack-techfinance-platform-mbc-${terraform.workspace}-alerts"
}