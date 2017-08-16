provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound/outbound traffic"
  
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}



resource "aws_instance" "av_avdpool_ng" {
  ami = "ami-82be18ed" 
  instance_type = "t2.micro"
  key_name = "aws-demo"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  
  user_data = <<-EOF
              #!/bin/bash
              yum -y install git
              git clone https://github.com/edigonzales/aws-demo-2017-08-XY.git /tmp/aws-demo
              sed -i -e 's/dbHost/${aws_security_group.allow_all.id}/g' /tmp/aws-demo/use_cases/04/av_avdpool_ng/build.gradle
              #### sed gradle.build
              #export SDKMAN_DIR="/usr/local/sdkman" && curl -s "https://get.sdkman.io" | bash
              #source "/usr/local/sdkman/bin/sdkman-init.sh"
              #sed -i -e 's/sdkman_auto_answer=false/sdkman_auto_answer=true/g' /usr/local/sdkman/etc/config
              #sdk i gradle
              EOF

  tags {
    Name = "av-import"
  }
}

output "public_ip" {
  value = "${aws_instance.av_avdpool_ng.public_ip}"
}

