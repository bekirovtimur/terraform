
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

# I will create Resource group, Virtual Network and Subnet, because I don't have any existing
resource "azurerm_resource_group" "terraform_course" {
  name = var.resource_group_name
  location = var.resource_group_location
  
  tags = {
    "owner" = var.owner
  }
}

resource "azurerm_virtual_network" "terraform_course_network" {
  name = var.vnet_name
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.terraform_course.location
  resource_group_name = azurerm_resource_group.terraform_course.name

  tags = {
      "owner" = var.owner
  }
}

resource "azurerm_subnet" "terraform_course_subnet" {
  name = var.subnet_name
  resource_group_name = azurerm_resource_group.terraform_course.name
  virtual_network_name = azurerm_virtual_network.terraform_course_network.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "subnet_security" {
  subnet_id = azurerm_subnet.terraform_course_subnet.id
  network_security_group_id = data.azurerm_network_security_group.default.id
}

# Network security group hardcoded here, because in EPAM account we don't have permissions to create our security groups
data "azurerm_network_security_group" "default" {
  name = "epm-rdsp-westeurope-sg"
  resource_group_name = "epm-rdsp"
}

# Getting information using data sources according to homework task 1
data "azurerm_subnet" "terraform_course_subnet_data" {
  name = azurerm_subnet.terraform_course_subnet.name
  resource_group_name = azurerm_resource_group.terraform_course.name
  virtual_network_name = azurerm_virtual_network.terraform_course_network.name
}

data "azurerm_virtual_network" "terraform_course_network_data" {
  name = azurerm_virtual_network.terraform_course_network.name
  resource_group_name = azurerm_resource_group.terraform_course.name
}
