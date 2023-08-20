variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami" {
  type    = string
  default = "ami-05548f9cecf47b442"
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