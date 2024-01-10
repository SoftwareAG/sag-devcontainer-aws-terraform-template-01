variable "project_prefix" {
  type    = string
  default = "pj01"
}

variable "deployment_regions_list"{
  type = list(string)
  default = ["eu-central-1"]
}

variable "provided_meta_tags" {
  type = map(string)
  default = {
    "environment_type" = "development"
  }
}
