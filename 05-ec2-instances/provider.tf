

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {}

#data "aws_subnet" "default_subnets" {
# vpc_id = aws_default_vpc.default.id
#}

data "aws_ami" "aws_linux_2_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

# Http server -> 80 TCP, SSH 22 TCP, CIDR(Used to specify range of IP addresses.) ["0.0.0.0/0"]

resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id

  # Ingress for HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress for SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress for all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags are used to tie the resource to a specific environment which helps in identification
  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  ami = "ami-0a699202e5027c10d"
  #ami = data.aws_ami.aws_linux_2_latest
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  #subnet_id = data.aws_subnet.default_subnets.id
  subnet_id = "subnet-0f95b394e50f22512"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      # Install httpd, start, copy a file
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "sudo mkdir -p /var/www/html",
      "echo Virtual server is at ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
}
