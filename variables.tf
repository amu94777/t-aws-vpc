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