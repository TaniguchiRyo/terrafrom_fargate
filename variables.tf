variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "rds-db-password" {}
variable "aws_region" {
  default = "ap-northeast-1"
}

data "aws_caller_identity" "self" {}

# manage gip
variable "manage-gip" {
  type = map(any)
  default = {
    home = ""
  }
}

## Project Name
variable "project-name" {
  default = "iacontainer"
}

## env
variable "env" {
  default = "verif"
}

# AZ
variable "availability_zone" {
  type = map(any)

  default = {
    a = "ap-northeast-1a"
    c = "ap-northeast-1c"
  }
}

## VPC-CIDR
variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

## VPC-subnet(public and private)
variable "vpc_subnet" {
  type = map(any)

  default = {
    public-a  = "10.10.10.0/24"
    public-c  = "10.10.11.0/24"
    private-a = "10.10.30.0/24"
    private-c = "10.10.31.0/24"
  }
}
