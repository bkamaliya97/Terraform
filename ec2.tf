provider "aws" {
  access_key = "***"
  secret_key = "***"
  region = "ap-south-1"
}

provider "aws" {
  alias = "europe"
  region = "eu-west-1"
  access_key = "***"
  secret_key = "**"
}

resource "aws_instance" "ec2_mumbai" {
  ami = "ami-0cca134ec43cf708f"
  instance_type = "t2.micro"

}

resource "aws_instance" "ec2_europe" {
  ami = "ami-0fe0b2cf0e1f25c8a"
  instance_type = "t2.micro"
  provider = aws.europe
}