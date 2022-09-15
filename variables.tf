variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "us-west-1"
}

variable "cognito_pools" {
  description = "List of the Amazon Cognito user pool ARNs that will be provided api access via the authorizer"
  default     = ["arn:aws:cognito-idp:us-west-1:081924037451:userpool/us-west-1_SygBe8yTB"]
}