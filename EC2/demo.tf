provider "aws" {
  version = "~> 2.0"
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_subnet" {
  availability_zone = "us-east-1a"

}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "ssh-http" {
  name        = "ssh-http"
  description = "allow ssh and http traffic"
  vpc_id = "${aws_default_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    }
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "main" {
  ami           = "ami-062f7200baf2fa504"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.ssh-http.id}"]
  subnet_id     = "${aws_default_subnet.default_subnet.id}"
  # security_groups   = ["${aws_security_group.ssh-http.id}"]
  associate_public_ip_address = true
  key_name   = "${aws_key_pair.generated_key.key_name}"
}

resource "null_resource" "ssh_to_web_instance" {
  connection {
     user = "ec2-user"
     type = "ssh"
     agent = false
     host = "${aws_instance.main.public_dns}"
     private_key  = "${tls_private_key.example.private_key_pem}"
}
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }

}
  output "public_ip" {
    value = "${aws_instance.main.public_ip}"
}
  output "private_key" {
    value = "${tls_private_key.example.private_key_pem}"

}
