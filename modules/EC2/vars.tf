# variable "ami" {
#   type = string
#   description = "AMI-KEy"
#   default = "ami-04d9e855d716f9c99"
# }

# variable "public_subnets_id" {
#     type = string
#     description = "Subnet privae id"
#     default = "value"
# }

variable "public_subnets_id" {
    type        = any
    #type = string
    #description = "Public subnet id"
    #default = ""
}

variable "private_subnets_id" {
    type        = list(any)
    #description = "Private subnet id"
    #default = ""
}

variable "public_subnets_cidr" {
    type        = list(any)
}

variable "private_subnets_cidr" {
    type        = list(any)
}

variable "security_groups_ids" {
    type = any
}

variable "key_name" {
    type = string
}

variable "list_subnet" {
    type = list(string)
}