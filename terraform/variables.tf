# Common
variable "aws_region" {
  description = "Region for the VPC"
  default     = "ap-southeast-2"
}

# variable "ec2_ami" {
#   description = "CentOS"
#   default     = "ami-d8c21dba"
# }

variable "ec2_ami" {
  description = "Ubuntu 16.04"
  default     = "ami-0789a5fb42dcccc10"
}

variable "sg_cidr_blocks" { default = [ "0.0.0.0/0" ] }
variable "ec2_instance_type" { default = "t2.micro" }
variable "ec2_public_key" {}
variable "ec2_number_of_instances" { default = 2 }

variable "harbor-registry-bucket" {
  default     = "darumatic.harbor-registry"
}

variable "db_user" { default = "harbor" }
variable "db_password" { default = "changeme" }
variable "db_storage_size" { default = 10 }
variable "db_instance_class" { default = "db.t2.small" }
variable "db_backup_period" { default = 0 }
