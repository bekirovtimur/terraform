# Creating base resources:
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}
# First we need resource group for this project
resource "azurerm_resource_group" "terraform_course" {
  name = "${var.project_name}-rg"
  location = var.resource_location

  tags = {
    "owner" = var.owner
  }
}
# Second, is the network for our resources
resource "azurerm_virtual_network" "terraform_course_network" {
  name = "${var.project_name}-vnet"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.terraform_course.location
  resource_group_name = azurerm_resource_group.terraform_course.name

  tags = {
      "owner" = var.owner
  }
}
# And subnet in this network
resource "azurerm_subnet" "terraform_course_subnet" {
  name = "${var.project_name}-subnet"
  resource_group_name = azurerm_resource_group.terraform_course.name
  virtual_network_name = azurerm_virtual_network.terraform_course_network.name
  address_prefixes = ["10.0.1.0/24"]
}
# Also we need a public IP, to gain direct access from anywhere
resource "azurerm_public_ip" "terraform_course_public_ip" {
  name = "${var.project_name}-public-ip"
  resource_group_name = azurerm_resource_group.terraform_course.name
  location = var.resource_location
  allocation_method = "Dynamic"
}
