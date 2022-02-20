# First, let;s create network interface for our VM
resource "azurerm_network_interface" "terraform_course_nic" {
  name = "${var.project_name}-nic"
  location = var.resource_location
  resource_group_name = azurerm_resource_group.terraform_course.name

  ip_configuration {
    name = "${var.project_name}-ipconf"
    subnet_id = azurerm_subnet.terraform_course_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.terraform_course_public_ip.id
  }
}

# Second, the VM itself
resource "azurerm_virtual_machine" "terraform_course_vm" {
  name = "${var.project_name}-vm"
  location = var.resource_location
  resource_group_name = azurerm_resource_group.terraform_course.name
  network_interface_ids = [azurerm_network_interface.terraform_course_nic.id]
  vm_size = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
# I've tried to find 20.04 release, but it's not exist o_O
# Failure sending request: StatusCode=404 -- Original Error: Code="PlatformImageNotFound"
# Message="The platform image 'Canonical:UbuntuServer:20.04-LTS:latest' is not available.
# According to $(az vm image list | grep -i "ubuntu") 18.04-LTS is the latest
    version = "latest"
  }
  storage_os_disk {
    name = "storageosdisk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "srv-ubnt"
    admin_username = var.srv_admin_username
    admin_password = var.srv_admin_password
    custom_data = file("nginx-install.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    "owner" = var.owner
  }
}
