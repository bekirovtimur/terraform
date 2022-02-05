output "network_name" {
    value = data.azurerm_virtual_network.terraform_course_network_data.name
}

output "subnet_name" {
    value = data.azurerm_subnet.terraform_course_subnet_data.name
}

output "security_group_name" {
    value = data.azurerm_network_security_group.default.name
}