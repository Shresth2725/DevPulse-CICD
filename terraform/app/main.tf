data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

resource "aws_security_group" "devpulse_sg" {
  name = "devpulse-sg"
  description = "SG for devpulse application"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "SSH acess"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ var.allowed_ssh_cidr ]
  }

  ingress {
    description = "HTTP access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Backend API access"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devpulse-security-group"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Caonical
}

resource "aws_instance" "devpulse_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.devpulse_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "devpulse-ec2"
  }
}

