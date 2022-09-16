variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "us-west-1"
}

variable "route_53_zone_id" {
  description = "The hosted zone id from route 53 for the custom domain"
}