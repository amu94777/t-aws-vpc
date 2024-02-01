variable "cidr_block" {
    
  default = "10.0.0.0/16"
}
variable "enable_dns_hostnames" {
  type = bool
  default = true
}
variable "comman_tags" {
    type = map
    default = {
          project = "roboshop"
          environment = "dev"
          Terraform = true
    }
  
}
variable "vpc_tags" {
  type = map
  default = {}
}
variable "project_name" {
    type = string
    default = "roboshop"
   
}
variable "environment" {
    type = string
    default = "dev"
}
variable "gw_tags" {
  default = {}
}
variable "public_subnet_cidr" {
    type = list 
    validation  {
        condition = length(var.public_subnet_cidr) == 2
    error_message = "please give 2 subnet cidr"
    }
}
variable "private_subnet_cidr" {
    type = list 
    validation  {
        condition = length(var.private_subnet_cidr) == 2
    error_message = "please give 2 subnet cidr"
    }
}
variable "database_subnet_cidr" {
    type = list 
    validation  {
        condition = length(var.database_subnet_cidr) == 2
    error_message = "please give 2 subnet cidr"
    }
}
variable "public_subnet_tags" {
    default = {}
}
variable "private_subnet_tags" {
    default = {}
}
variable "database_subnet_tags" {
    default = {}
}
variable "public_route_table_tags" {
    default = {}
}
variable "private_route_table_tags" {
    default = {}
}
variable "database_route_table_tags" {
    default = {}
}
variable "aws_nat_gateway_tags" {
    default = {}
}


