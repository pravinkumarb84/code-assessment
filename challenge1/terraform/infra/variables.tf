variable "az_list" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "private_subnets_cidr" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", ]
}

variable "public_subnets_cidr" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24", ]
}

variable "role_arn" {
  type    = string
  default = ""
}