aws_region = "us-east-2"

vpc_cidr_block = "10.0.0.0/16"

enable_dns_hostnames = true

tags = {
  owner   = "Dhiraj_Walke"
  purpose = "class_task"
  enddate = "10/07/2022"
}

vpc_public_subnet_count = "3"

vpc_private_subnet_count = "3"

map_public_ip_on_launch = true

map_public_ip_on_launch_1 = false

instance_count = "2"

instance_type = "t2.micro"