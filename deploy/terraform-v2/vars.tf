######################################################################
##  VARS
######################################################################
variable "env" {
  type    = string
  default = "poc"  
}
variable "app_name" {
  type    = string
  default = "tfdemo"
}

variable "region" {
  type    = string
  default = "centralus"
}

variable "loc" {
  type    = string
  default = "cus"
}

variable "index" {
  type    = string
  default = "01"
}
