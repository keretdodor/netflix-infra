variable "env" {
   description = "Deployment environment"
   type        = string
}

variable "region" {
   description = "AWS region"
   type        = string
}

variable "ami_id" {
   description = "EC2 Ubuntu AMI"
   type        = string
}

variable "instance_type" {
   description = "Instance Type"
   type        = string
}

variable "key_name" {
   description = "key name"
   type        = string
}

variable "key_path" {
   description = "key file path"
   type        = string
   default     = null
}

variable "bucket_name" {
   description = "bucket name"
   type        = string
}

variable "az" {
   description = "deafult avaliablity zone"
   type        = string
}
