resource "tls_private_key" "webserverssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" {
  value = tls_private_key.webserverssh.private_key_pem
  sensitive = true
}

data "azurerm_image" "webserverimage" {
  resource_group_name = "imagesourcerg"
  name = "webserverimagesource-image-20210522182910"
}

resource "azurerm_public_ip" "bastionpip" {
  name = "bastionpip"
  location = "japaneast"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Static"
  sku = "Standard"
}

# resource "azurerm_bastion_host" "azurebastion" {
#   name = "azurebastion"
#   location = "japaneast"
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name = "bastionconfiguration"
#     subnet_id = azurerm_subnet.bastionsubnet.id
#     public_ip_address_id = azurerm_public_ip.bastionpip.id
#   }
# }

resource "azurerm_linux_virtual_machine_scale_set" "webserverss" {
  name = "webserver-vmss"
  resource_group_name = azurerm_resource_group.rg.name
  location = "japaneast"
  sku = "Standard_B2ms"
  instances = 2
  admin_username = "azureuser"
  upgrade_mode = "Automatic"

  admin_ssh_key {
    username = "azureuser"
    public_key = tls_private_key.webserverssh.public_key_openssh
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_image.webserverimage.id

  network_interface {
    name = "webservernic"
    primary = true

    ip_configuration {
      name      = "nicconfiguration"
      primary   = true
      subnet_id = azurerm_subnet.backendsubnet.id
      # application_gateway_backend_address_pool_ids = azurerm_application_gateway.webserverag.backend_address_pool[*].id
    }
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "DependencyAgentLinux" {
  name = "DependencyAgentLinux"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.webserverss.id
  publisher = "Microsoft.Azure.Monitoring.DependencyAgent"
  type = "DependencyAgentLinux"
  type_handler_version = "9.10"
}

resource "azurerm_virtual_machine_scale_set_extension" "OMSAgentForLinux" {
  name = "OMSAgentForLinux"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.webserverss.id
  publisher = "Microsoft.EnterpriseCloud.Monitoring"
  type = "OMSAgentForLinux"
  type_handler_version = "1.13"

  settings = <<SETTINGS
    {
      "workspaceId": "${azurerm_log_analytics_workspace.webserverlogana.workspace_id}"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${azurerm_log_analytics_workspace.webserverlogana.primary_shared_key}"
    }
  PROTECTED_SETTINGS
}