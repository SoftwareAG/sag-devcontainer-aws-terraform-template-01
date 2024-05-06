variable "email_4_notifications" {
  type    = string
  default = "not.sure@awesome.movie"
}

# Use one region for now, but leave open the future option to use more
variable "deployment_regions_list" {
  type    = list(string)
  default = ["eu-central-1"]
}
