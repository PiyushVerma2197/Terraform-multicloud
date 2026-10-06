output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "vnet_cidr" {
  value = var.vnet_cidr
}

output "public_subnet_ids" {
  value = azurerm_subnet.public[*].id
}

output "private_subnet_ids" {
  value = azurerm_subnet.private[*].id
}

output "public_nsg_id" {
  value = azurerm_network_security_group.public.id
}

output "private_route_table_id" {
  value = azurerm_route_table.private.id
}

output "application_gateway_id" {
  value = azurerm_application_gateway.app.id
}

output "application_gateway_public_ip" {
  value = azurerm_public_ip.app_gateway.ip_address
}