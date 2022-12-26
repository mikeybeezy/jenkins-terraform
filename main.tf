provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_default_vpc" "default_vpc" {
  tags = {
    "name" = "default VPC"
  }

}


data "aws_availability_zones" "available" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Default subnet for us-west-2a"
  }
}

# Security  Group
resource "aws_security_group" "jenkins_sg" {
  name        = "allow_8080_and_22"
  description = "Allow 8080 and 22 inbound traffic"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # currently open to the world
  }

  ingress {
    description = "Jenkins HTTP access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # currently open to the world
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Ports"
  }
}

# JENKINS SERVER 

resource "aws_instance" "jenkins_server" {
  ami                    = "ami-00463ddd1036a8eb6" # eu-west-1 ami-05e786af422f8082a
  instance_type          = "t2.micro"
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = "mb-devops-key"

  tags = {
    Name = "Jenkins_server"
  }
}


#SSH to instance 

resource "null_resource" "instance_bootstrap" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    cluster_instance_ids = join(",", aws_instance.jenkins_server.*.id)
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/Documents/keys/mb-devops-key.pem")
    host        = aws_instance.jenkins_server.public_ip
  }

  provisioner "file" {
    source      = "install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"

  }


  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo apt install default-jre -y",
      "sudo chmod +x /tmp/install_jenkins.sh",
      "sh /tmp/install_jenkins.sh"

    ]
  }

  depends_on = [
    aws_instance.jenkins_server
  ]
}

output "jenkins-url" {
  value = join("", ["http://", aws_instance.jenkins_server.public_dns, ":", "8080"])

}
