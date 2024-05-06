# Use one region for now, but leave open the future option to use more
variable "deployment_regions_list" {
  type    = list(string)
  default = ["eu-central-1"]
}

variable "provided_meta_tags" {
  type = map(string)
  default = {
    "environment_type" = "sandbox"
    "aws_maintainer"   = "Nana"
  }
}
