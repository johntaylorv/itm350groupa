provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SSH open to anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # HTTP open to anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # all outbound traffic allowed
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0a887e401f7654935" # Amazon Linux 2 AMI in us-west-2
  instance_type = "t2.micro"

  security_groups = [aws_security_group.allow_ssh_http.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              sudo docker pull johntaylorv/planet:latest
              sudo docker run -d -p 80:80 johntaylorv/planet:latest
              EOF

  tags = {
    Name = "PlanetAppServer"
  }
}
