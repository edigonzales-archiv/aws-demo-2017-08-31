## Manuell im Browser

```
https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#
```

```
Launch Instance
```

```
Ubuntu Server 16.04 LTS (HVM), SSD Volume Type - ami-1e339e71
```

```
t2.micro
```

```
Auto-assign Public IP: (Enable)
```

```
IAM role
```

```
Security Group: All TCP / 0.0.0.0/0
```

```
Launch: Choose an existing key pair / aws-demo
```

```
EC2 Dashboard -> pending/running...
```

```
IPv4 Public IP: ...
```

```
Monitoring zeigen
```

```
chmod 400 .aws-keys/aws-demo.pem
```

```
ssh -i .aws-keys/aws-demo.pem ubuntu@54.93.246.210
```

(Username unterschiedlich je Linux: Amazon-Linux=ec2-user)


```
sudo apt-get update
sudo apt-get --yes install openjdk-8-jre-headless openjdk-8-jdk unzip zip
git clone https://github.com/sogis/ilivalidator-web-service.git
cd ilivalidator-web-service
./gradlew build
./build/libs/ilivalidator-web-service-0.0.8.jar
```

```
http://54.93.246.210:8888/ilivalidator/
```
