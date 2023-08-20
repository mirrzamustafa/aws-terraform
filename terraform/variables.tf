variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami" {
  type    = string
  default = "ami-011899242bb902164"
}

variable "ssh_key" {
  type = string
}

variable "app_bucket_name" {
  type = string
}

variable "instance_type" {
  type = string
}
