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

resource "aws_instance" "ilivalidator-web-service" {
  ami = "ami-7e5cf211" 
  instance_type = "t2.micro"
  key_name = "aws-demo"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  
  user_data = <<-EOF
              #!/bin/bash
              nohup sudo -u ubuntu /home/ubuntu/ilivalidator-web-service/build/libs/ilivalidator-web-service-0.0.8.jar
              EOF

  tags {
    Name = "ilivalidator-web-service-example"
  }
}

output "public_ip" {
  value = "${aws_instance.ilivalidator-web-service.public_ip}"
}

