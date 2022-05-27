variable "enviroment" {
  description = "Deployment Environment"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
}

variable "availability_zones" {
  type        = list(any)
  description = "AZ in which all the resources will be deployed"
}
variable "region" {
  #default = "ap-southeast-1"
  default = "region of VPC"
}