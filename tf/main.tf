terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.55"
    }
  }

  required_version = ">= 1.7.0"
  
 backend "s3" {
    bucket = "dork-tf-state"
    key    = "tfstate.json"
    region = "eu-north-1"
    
  }

}

provider "aws" {
  region  = var.region
}

resource "aws_instance" "netflix_app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  user_data = file("./deploy.sh")
  availability_zone = "${var.region}${var.az}"
  key_name = var.key_name

  subnet_id                   = module.netflix_app_vpc.public_subnets[1]
  vpc_security_group_ids      = [aws_security_group.netflix_app_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "dor-server"
  }

  depends_on = [aws_s3_bucket.frontend-bucket,
                aws_security_group.netflix_app_sg
                ] 
}
resource "aws_security_group" "netflix_app_sg" {
  name        = "netflix-app-sg"   # change <your-name> accordingly
  description = "Allow SSH and HTTP traffic"
  vpc_id      = module.netflix_app_vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 8080  
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000  
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_ebs_volume" "frontend-volume" {
  availability_zone = "${var.region}${var.az}"
  size              = 5

  tags = {
    Name = "frontend-volume"
  }
}
resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdh"  
  volume_id   = aws_ebs_volume.frontend-volume.id
  instance_id = aws_instance.netflix_app.id
}
resource "aws_s3_bucket" "frontend-bucket" {
  bucket = var.bucket_name # Ensure the bucket name is globally unique

  tags = {
    Name        = "frontend-bucket-netflix-infra-aa"
    Environment = var.env
  }
}
module "netflix_app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "Bogs"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  map_public_ip_on_launch = true

  enable_nat_gateway = false

  tags = {
    Env         = var.env
  }
}