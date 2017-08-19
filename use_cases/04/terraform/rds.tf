provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "postgres" {
  name        = "postgres"
  description = "Allow only postgres inbound."
  
  ingress {
    from_port = 5432
    to_port = 5432
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
    Name = "allow_pg"
  }
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

resource "aws_db_instance" "aws-test-db" {
    identifier = "aws-test"
    allocated_storage = 5
    storage_type = "gp2"    
    engine = "postgres"
    engine_version = "9.6.3"
    instance_class = "db.t2.micro"
    name = "xanadu2"
    port = 5432
    username = "stefan"
    password = "ziegler12"
    multi_az = false
    publicly_accessible = true
    backup_retention_period = "0"
    apply_immediately = "true"
    auto_minor_version_upgrade = false
    vpc_security_group_ids = ["${aws_security_group.postgres.id}"]    
    skip_final_snapshot = true
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
              ####sed -i -e 's/999.999.999.999/${aws_db_instance.aws-test-db.address}/g' /tmp/aws-demo/use_cases/04/av_avdpool_ng/build.gradle
              #/tmp/aws-demo/use_cases/04/av_avdpool_ng/gradlew -p /tmp/aws-demo/use_cases/04/av_avdpool_ng/ tasks --all

              # shutdown ????
              EOF

  tags {
    Name = "av_avdpool_ng"
  }
}



output "endpoints" {
    value = "${aws_db_instance.aws-test-db.address}"
}

