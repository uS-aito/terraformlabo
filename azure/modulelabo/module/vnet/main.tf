resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  resource_group_name = var.rg
  address_space = var.address_space
  location = var.location
}

resource "azurerm_subnet" "subnet" {
    name = var.subnet_name
    resource_group_name = var.rg
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.subnet_address_prefix
}