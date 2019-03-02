variable "cluster-name" {}
variable "vpc-id" {}
variable "instance-type" {}
variable "asg-min" {}
variable "asg-max" {}
variable "asg-desired" {}

variable "vpc-private-cidrs" {
  type = "list"
}

variable "vpc-public-cidrs" {
  type = "list"
}
