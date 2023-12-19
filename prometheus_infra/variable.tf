variable "vpcname" {
  type = string   
  default = "tf"
}
variable "vpctenancy" {
    type = string
    default = "default"
}
variable "vpccidr" {
  type = string  
  default = "10.0.0.0/16"
}
variable "pub_sub_names" {
  type = list(string)  
  default = ["tf-pub-sub-01", "tf-pub-sub-02"]
}
variable "pubcidr" {
  type = list(string)    
  default = ["10.0.0.0/18", "10.0.64.0/18"]
}
variable "pvt_sub_names" {
  type = list(string)    
  default = ["tf-pvt-sub-01", "tf-pvt-sub-02"]
}
variable "pvtcidr" {
  type = list(string)    
  default = ["10.0.128.0/18", "10.0.192.0/18"]
}
variable "pub_instance_name" {
  type = string 
  default = "bastion-instance"
}
variable "pvt_instance_name" {
  type = list(string)  
  default = ["tf-Master","tf-Slave"]  
}
variable "igwname" {
  type = string   
  default = "tf-igw-01"
}
variable "natname" {
  type = string   
  default = "tf-nat-01"
}
variable "public_rt_names" {
  type = string   
  default = "tf-route-pub-01"
}
variable "private_rt_names" {
  type = string   
  default = "tf-route-pvt-01"
}
variable "instancetype" {
  type = string   
  default = "t2.micro"
}
variable "secgrp" {
  type = string   
  default = "tf"
}
variable "keyname" {
  type = string
  default = "mykey.pem"
}
