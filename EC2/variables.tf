variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  description = "The AWS type for your instance"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH Key name"
  default = "example_key"
}
