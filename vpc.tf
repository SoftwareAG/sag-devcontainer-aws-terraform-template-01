resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = merge(var.provided_meta_tags, {
    Name="my_vpc", 
    Project="${var.project_prefix}_my_project"
  })
}
