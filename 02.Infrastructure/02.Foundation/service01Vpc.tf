
# central VPC
resource "aws_vpc" "service_01" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.layer_tags, {
    Name = "service_01_vpc"
  })
}

resource "aws_subnet" "service_01_public_subnet" {
  vpc_id     = aws_vpc.service_01.id
  cidr_block = "10.1.1.0/24"

  tags = merge(local.layer_tags, {
    Name = "service_01_public_subnet"
  })
}

resource "aws_subnet" "service_01_private_subnet" {
  vpc_id     = aws_vpc.service_01.id
  cidr_block = "10.1.2.0/24"

  tags = merge(local.layer_tags, {
    Name = "service_01_private_subnet"
  })
}

# default security group does not allow anything
resource "aws_default_security_group" "service_01_vpc" {
  vpc_id = aws_vpc.service_01.id

  tags = merge(local.layer_tags, { "Name" = "service_01_vpc_dsg" })
}

# flow log for the vpc
resource "aws_flow_log" "service_01_flow_log"{
  log_destination = aws_cloudwatch_log_group.central_cw_log_group.arn
  iam_role_arn = aws_iam_role.logger_artifact_role.arn
  traffic_type = "ALL"
  vpc_id = aws_vpc.service_01.id
  
  tags = merge(local.layer_tags, { "Name" = "service_01_vpc_dsg" })
}
