output "instance_public_ip_0" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.apache_http[0].public_ip
}

output "instance_public_ip_1" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.apache_http[1].public_ip
}