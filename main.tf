terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
  profile = "default"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow Jenkins Traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow from Personal CIDR block"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = var.cidr_block
    self             = var.cidr_block == null ? true : false
  }

  ingress {
    description      = "Allow SSH from Personal CIDR block"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.cidr_block
    self             = var.cidr_block == null ? true : false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Jenkins SG"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_instance" "web" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  key_name        = var.key_name
  security_groups = [aws_security_group.jenkins_sg.name]
  user_data       = "${file("install_jenkins.sh")}"
  tags = {
    Name = "Jenkins"
  }
}


resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_instance.web]

  create_duration = "30s"
}

resource "null_resource" "null" {
provisioner "remote-exec" {
    inline = [
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",

    ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("newkeyjenkins.pem")
    host     = aws_instance.web.private_ip
  }

}

 depends_on = [time_sleep.wait_30_seconds]
}
