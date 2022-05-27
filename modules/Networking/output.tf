output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  #value = ["${aws_subnet.public_subnet.*.id}"]

  value = aws_subnet.public_subnet.*.id
}

output "private_subnets_id" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "security_groups_ids" {
  value = ["${aws_security_group.default.id}"]
}

# output "public_subnets_cidr" {
#   value = public_subnets_cidr
# }

# output "private_subnets_cidr" {
#   value = private_subnets_cidr
# }

output "public_subnets_cidr" {
  value = ["${aws_subnet.public_subnet.*.cidr_block}"]
}

output "private_subnets_cidr" {
  value = ["${aws_subnet.private_subnet.*.cidr_block}"]
  #value = ["${aws_subnet.private_subnet.*.id}"]
}





# output "public_route_table" {
#   value = aws_route_table.public.id
# }