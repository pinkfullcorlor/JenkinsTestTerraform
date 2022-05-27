variable "AWS_ACCESS_KEY" {
  default = ""
}
variable "AWS_SECRET_KEY" {
  default = ""
}

variable "region" {
  default = "ap-southeast-1"
}

variable "environment" {
  description = "Deployment Environment"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  #default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
  #default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  #default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}



# variable "ami" {
#   type = string
#   description = "AMI-KEy"
#   #default = "ami-04d9e855d716f9c99"
# }

variable "key_name" {
  type = string
}



####################
# variable "environment" {
#   description = "Deployment Environment"
# }

# variable "vpc_cidr" {
#   description = "CIDR block of the vpc"
# }

# variable "public_subnets_cidr" {
#   type        = list(any)
#   description = "CIDR block for Public Subnet"
# }

# variable "private_subnets_cidr" {
#   type        = list(any)
#   description = "CIDR block for Private Subnet"
# }

# variable "availability_zones" {
#   type        = list(any)
#   description = "AZ in which all the resources will be deployed"
# }
# variable "region" {
#   default = "ap-southeast-1"
# }