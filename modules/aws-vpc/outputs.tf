output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "public_route_table_ids" {
  value = aws_route_table.public_route_tables.*.id
}

output "private_route_table_ids" {
  value = aws_route_table.private_route_tables.*.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat_gws.*.id
}