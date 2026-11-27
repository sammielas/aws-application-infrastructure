output "vpc_id" {
  description = "ID of the application VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed by logical name"
  value = {
    for key, subnet in aws_subnet.this :
    key => subnet.id if var.subnets[key].public
  }
}

output "private_subnet_ids" {
  description = "Private subnet IDs keyed by logical name"
  value = {
    for key, subnet in aws_subnet.this :
    key => subnet.id if !var.subnets[key].public
  }
}

output "private_route_table_ids" {
  description = "Private route table IDs keyed by logical name"
  value = {
    for key, route_table in aws_route_table.private :
    key => route_table.id
  }
}
