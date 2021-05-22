resource "azurerm_resource_group" "rg" {
  name = "terraformrg"
  location = "japaneast"
}

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

resource "azurerm_public_ip" "webserverpip" {
  name = "webserverpip"
  location = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Dynamic"
}

resource "azurerm_network_security_group" "webservernsg" {
  name = "webservernsg"
  location = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "webservernic" {
  name = "webservernic"
  location = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "webservernic_configuration"
    subnet_id = azurerm_subnet.frontendsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.webserverpip.id
  }
}

resource "azurerm_network_interface_security_group_association" "webservernicassociation" {
  network_interface_id = azurerm_network_interface.webservernic.id
  network_security_group_id = azurerm_network_security_group.webservernsg.id
}

resource "tls_private_key" "webserverssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" {
  value = tls_private_key.webserverssh.private_key_pem
  sensitive = true
}

resource "azurerm_linux_virtual_machine" "webserver" {
  name = "webserver"
  location = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [ 
    azurerm_network_interface.webservernic.id
  ]
  size = "Standard_B2ms"

  os_disk {
    name = "webserverosdisk"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name = "webserver"
  admin_username = "azureuser"
  disable_password_authentication = true
  
  admin_ssh_key {
    username = "azureuser"
    public_key = tls_private_key.webserverssh.public_key_openssh
  }
}

resource "azurerm_subnet" "bastionsubnet" {
  name = "AzureBastionSubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.webvirtualnetwork.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_public_ip" "bastionpip" {
  name = "bastionpip"
  location = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_bastion_host" "azurebastion" {
  name = "azurebastion"
  location = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "bastionconfiguration"
    subnet_id = azurerm_subnet.bastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastionpip.id
  }
}