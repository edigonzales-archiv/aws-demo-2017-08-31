provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags {
    Name = "allow_all"
  }
}

resource "aws_instance" "example" {
  #ami = "ami-82be18ed" # Amazon Linux
  ami = "ami-1c45e273" # Ubuntu 16.04
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name = "terraform-example"
  }
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}

