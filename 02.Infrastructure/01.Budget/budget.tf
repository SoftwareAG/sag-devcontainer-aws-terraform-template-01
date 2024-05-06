resource "aws_budgets_budget" "main_budget" {
  name         = "main_budget"
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = "160"
  limit_unit   = "USD"
  cost_filter {
    name   = "TagKeyValue"
    values = ["company_name$Valdoridex"]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 90
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.email_4_notifications]
  }
}
