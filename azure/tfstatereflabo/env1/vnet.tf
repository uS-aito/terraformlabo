resource "azurerm_resource_group" "rg" {
  name = "tfstatereflabo"
  location = "japaneast"
}

resource "azurerm_virtual_network" "samplevnet" {
  name = "samplevnet"
  address_space = ["10.0.0.0/16"]
  location = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "samplesubnet" {
  name = "samplesubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.samplevnet.name
  address_prefixes = ["10.0.1.0/24"]
}

output "vnet_name" {
    value = azurerm_virtual_network.samplevnet.name
}

output "vnet_rg" {
    value = azurerm_virtual_network.samplevnet.resource_group_name
}

output "subnet_id" {
    value = azurerm_subnet.samplesubnet.id
}