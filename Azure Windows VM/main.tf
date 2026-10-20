
# Create a resource group.
resource "azurerm_resource_group" "rg" {
    name = var.rg_name
    location = var.rg_loc

    timeouts {
        create = "10m"
        delete = "15m"
    }
}

resource "azurerm_virtual_network" "rg_az_vnetwork" {
    name = "${var.rg_name}-network"
    location = var.rg_loc
    resource_group_name = var.rg_name
    address_space = ["10.0.0.0/16"]

    depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_subnet" "rg_az_subnet" {
    name = "${var.rg_name}-subnet"
  resource_group_name = var.rg_name
  virtual_network_name = azurerm_virtual_network.rg_az_vnetwork.name
  address_prefixes = ["10.0.1.0/24"]
}

#resource "azurerm_public_ip" "pub_ip" {
#  name = var.public_ip
#  location = var.rg_loc
#  resource_group_name = var.rg_name
#  allocation_method = "Dynamic"
#}

module "windows-vm" {
    source = "./modules/windows-vm"

    resource_group_name = var.rg_name
    location = var.rg_loc
    subnet_id = azurerm_subnet.rg_az_subnet.id

}