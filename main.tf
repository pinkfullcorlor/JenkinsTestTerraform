# terraform {
#   required_providers {
#     aws = {
#         source = "hashicorp/aws"
#         version = "~>3.27"
#     }
#   }
#   required_version = ">= 0.14.9"
# }

# provider "aws" {
#     profile = "default"
#     region = "ap-southeast-1"
# }

# resource "aws_instance" "app_server" {
#   ami = "ami-0022f774911c1d690"
#   instance_type = "t2.micro"

#   tags = {
#     "key" = "value"
#     "Name" = "ExampleAppServerInstance"
#   }
# }
provider "aws" {
  region     = var.region
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}


# module "Networking" {
#   source               = "./modules/Networking"
#   region               = var.region
#   environment          = var.environment
#   vpc_cidr             = var.vpc_cidr
#   public_subnets_cidr  = var.public_subnets_cidr
#   private_subnets_cidr = var.private_subnets_cidr
#   availability_zones   = local.production_availability_zones
# }

resource "random_id" "random_id_prefix" {
  byte_length = 2
}

locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "Networking" {
  source               = "./modules/Networking"
  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.production_availability_zones  
}

module "EC2" {
  source    = "./modules/EC2"

  public_subnets_id = module.Networking.public_subnets_id
  private_subnets_id = module.Networking.private_subnets_id
  
  public_subnets_cidr = module.Networking.public_subnets_cidr
  private_subnets_cidr = module.Networking.private_subnets_cidr

  security_groups_ids = module.Networking.security_groups_ids

  key_name = var.key_name

  list_subnet = [ "value" ]
}

module "LoadBalancing" {
  source = "./modules/LoadBalancing"

  environment          = var.environment
  security_groups_ids = module.Networking.security_groups_ids
  public_subnets_id = module.Networking.public_subnets_id

  vpc_id            = module.Networking.vpc_id
  
}

output "name" {
    value = module.Networking.public_subnets_id
}
