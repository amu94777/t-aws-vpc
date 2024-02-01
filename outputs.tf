output "vpc_info" {
    value = aws_vpc.main
}
output "vpc_id" {
    value = aws_vpc.main.id
  
}
output "azs" {
    value = data.aws_availability_zones.azs.names
}