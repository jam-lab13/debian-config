provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = file("example-key.pub")
}

resource "aws_security_group" "vpn" {
  name_prefix = "vpn"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vpn" {
  count         = var.instances_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.vpn.id]
  user_data     = <<-EOF
                  #!/bin/bash
                  echo "deb http://build.openvpn.net/debian/openvpn/release/2.5/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/openvpn.list
                  wget -qO - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
                  apt-get update
                  apt-get install -y openvpn
                  EOF

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("example-key.pem")
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${self.public_ip}, playbook.yml"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "vpn-server-${count.index+1}"
  }
}

resource "aws_eip" "vpn" {
  count = var.instances_count
  instance = aws_instance.vpn[count.index].id
}

output "vpn_server_ips" {
  value = aws_eip.vpn.*.public_ip
}
