####  CLOUD PROVIDER VARS   #################################################
variable "provider_access_key" {
}
variable "provider_secret_key" {
}
variable "provider_region" {
}
####  VPC VARS  #############################################################
variable "vpc_cidr_block" {
}
####  SUBNETS VARS ##########################################################
variable "availability_zone_1" {
}
variable "availability_zone_2" {
}


variable "pub_snet_1_cidr_block" {
}
variable "prv_snet_1_cidr_block" {
}

variable "pub_snet_2_cidr_block" {
}
variable "prv_snet_2_cidr_block" {
}

####  EC2 INSTANCES VARS  ######################################################
variable "instance_ami" {
}
variable "instance_type" {
}
variable "instance_ec2_wsrv_1_tag_name" {
}
variable "instance_ec2_wsrv_2_tag_name" {
}
