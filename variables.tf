variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resource tagging"
  default = {
  }
}

variable "vpc_public_subnet_count" {
  type        = number
  description = "number of subnets to create in VPC"
}

variable "vpc_private_subnet_count" {
  type        = number
  description = "number of subnets to create in VPC"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
}

variable "map_public_ip_on_launch_1" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create in VPC"
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instance"
}