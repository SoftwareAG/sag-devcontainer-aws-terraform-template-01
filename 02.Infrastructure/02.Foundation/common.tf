locals {
  layer_tags = merge(var.provided_meta_tags, {
    "company_name" = "Valdoridex"
    "layer_name"   = "Foundation"
  })
}

resource "aws_resourcegroups_group" "resource_group" {
  name = "Valdoridex_rg"
  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      "TagFilters" = [
        {
          "Key"= "company_name",
          "Values"= ["Valdoridex"]
        }
      ]
    })
  }
  tags = merge(local.layer_tags, { "Name" = "Valdoridex Resource Group" })
}

# flow logs to write into a cloudwatch log group
# Checkov seems to recommend 1 year retention for logs. Not the case here, we are exploring. Do it in production though
# trunk-ignore(checkov/CKV_AWS_338)
resource "aws_cloudwatch_log_group" "central_cw_log_group" {
  name = "central_cw_log_group"
  retention_in_days = 3
  kms_key_id = aws_kms_key.base_key_pair.arn

  tags = merge(local.layer_tags, { "Name" = "central_cw_log_group" })
}

# This is our main key for encryption
resource "aws_kms_key" "base_key_pair" {
  description             = "Our central KMS key"
  deletion_window_in_days = 8
  enable_key_rotation     = true
  tags                    = merge(local.layer_tags, { "Name" = "base_key_pair" })
}

resource "aws_kms_key_policy" "main_key_access_policy" {
  key_id = aws_kms_key.base_key_pair.id
  policy = data.aws_iam_policy_document.allow_kms_actions.json
}

# Declare the required access to KMS actions by the logging services and the main account principal
data "aws_iam_policy_document" "allow_kms_actions" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.id]
    }

    actions = ["kms:*"]

    resources = [aws_kms_key.base_key_pair.arn]
  }
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = formatlist("logs.%s.amazonaws.com", var.deployment_regions_list)
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = [aws_kms_key.base_key_pair.arn]
  }
}

data "aws_caller_identity" "current" {}

##### Required policies to enable logging

# Allow creation of logging artifacts and entries
data "aws_iam_policy_document" "allow_logging_policy_document" {

  statement {
    effect = "Allow"
    actions = [
      # "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      #"logs:DescribeLogGroups",
      #"logs:DescribeLogStreams",
    ]
    resources = [aws_cloudwatch_log_group.central_cw_log_group.arn]
  }
}

# Attach the allow logging policy to the role "logger_artifact"
resource "aws_iam_role_policy" "allow_logging_for_logger_artifact" {
  name   = "allow_logging"
  role   = aws_iam_role.logger_artifact_role.id
  policy = data.aws_iam_policy_document.allow_logging_policy_document.json
}

# Allow the service vpc-flow-logs to execute the action "assume role"
data "aws_iam_policy_document" "assume_role_for_logging" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

# Role allowing for logging
resource "aws_iam_role" "logger_artifact_role" {
  name               = "vdx-central-logger-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_for_logging.json
  # we use the managed policy to log
  # managed_policy_arns = [data.aws_iam_policy.full_log_policy.arn]
  tags = merge(local.layer_tags, { Name = "logger_artifact_role" })
}
