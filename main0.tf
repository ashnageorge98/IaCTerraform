provider "azurerm" {
features {}
}
reaource "azurerm_resource_group" "rg" {
name = "example-resources"
location = East US"
}
resource "azurerm_virtual_network" "vnet" {
name = "example-vnet"
address_space = ["10.0.0.0/16"]
location=azurerm_resource_group.rg.location
resource_group_name=azurerm_resource_group.rg.name
}
resource "azurerm_subnet""subnet" {
name = "example-subnet"
resource_group_name=azurerm_resource_group.rg.name
virtuak_network_nam=azurerm_virtual_network.vnet.name
address_prefizes=["10.0.1.0/24"
}
resource "azurerm_network_interface" "nic" {
name = "example-nic"
location= "azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name

ip_configuration {
name = "internal"
subnet_id = azurerm_subnet.subnet.id
private_ip_adress_allocation= "Dynamic"
}
}
resource "azurerm_virtual_machine" "vm" {
name = "example-vm"
location=azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
network_interface_ids = [azurerm_network_interface.nic.id]
vm_size = "Standard_DS1_v2"

storage_os_disk {
name = "example-os-dis"
caching = "ReadWrite"
create_option = "FromImage"
managed_disk_type = "Standard_LRS"
}
storage_image_reference {
publisher = "Canonical"
offer = "UbuntuServer"
sku = "18.04-LTS"
version = "latest"
}
os_profile_linux_config {
disabled_password_authentication = false
}
}

