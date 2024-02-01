resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(var.comman_tags,var.vpc_tags)
       {
        Name = "${var.project_name}-${var.environment}"
       }
      
}