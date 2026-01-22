output "ec2_public_ip" {
  description = "Public IP of DevPulse EC2 instance"
  value       = aws_instance.devpulse_ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of DevPulse EC2 instance"
  value       = aws_instance.devpulse_ec2.public_dns
}
