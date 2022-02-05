variable "resource_group_name" {
  description = "Resource group name"
#  default = "tbekirov-terraform-course-rg"
  }

variable "resource_group_location" {
  description = "Resource group location"
#  default = "West Europe"
  }

variable "owner" {
  description = "Resources owner"
#  default = "Timur_Bekirov"
  }

variable "vnet_name" {
  description = "Virtual network name"
#  default = "tbekirov-vnet"
  }

variable "subnet_name" {
  description = "Subnet name"
#  default = "tbekirov-subnet"
  }