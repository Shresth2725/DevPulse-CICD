resource "aws_instance" "jenkins_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = "DevPulse-Devops-Key"

  associate_public_ip_address = true

  tags = {
    Name = "jenkins-ec2"
  }
}
