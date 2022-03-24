output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "azurerm_virtual_network_name" {
  value = azurerm_virtual_network.lab_vnet.name
}

output "azure_created_subnets" {
  value = azurerm_virtual_network.lab_vnet.subnet.*.name
}

output "public_ip_address" {
  value = azurerm_public_ip.vm_public_web_pip.ip_address
}

output "public_ip_fqdn" {
  value = azurerm_public_ip.vm_public_web_pip.fqdn
}