resource "azurerm_virtual_network" "webvirtualnetwork" {
  name = "webvirtualnetwork"
  address_space = ["10.0.0.0/16"]
  location = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "frontendsubnet" {
  name = "frontendsubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.webvirtualnetwork.name
  address_prefixes = [ "10.0.0.0/24" ]
}

resource "azurerm_subnet" "backendsubnet" {
  name = "backendsubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.webvirtualnetwork.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_subnet" "bastionsubnet" {
  name = "AzureBastionSubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.webvirtualnetwork.name
  address_prefixes = [ "10.0.100.0/24" ]
}