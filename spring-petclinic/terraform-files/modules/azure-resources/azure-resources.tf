# Resource Group 
resource "azurerm_resource_group" "this" {

  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
  }
}

# Azure VNet
resource "azurerm_virtual_network" "this" {

  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  address_space = [
    var.vnet_cidr
  ]

  tags = {
    Environment = var.environment
  }
}

# Azure Public & Private Subnet 
resource "azurerm_subnet" "public" {

  count                = length(var.public_subnet_cidrs)
  name                 = "${var.environment}-public-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [
    var.public_subnet_cidrs[count.index]
  ]
}

resource "azurerm_subnet" "private" {

  count                = length(var.private_subnet_cidrs)
  name                 = "${var.environment}-private-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name

  address_prefixes = [
    var.private_subnet_cidrs[count.index]
  ]
}

# Azure NSG
resource "azurerm_network_security_group" "private" {

  name                = "${var.environment}-private-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_subnet_network_security_group_association" "public" {

  count                     = length(azurerm_subnet.public)
  subnet_id                 = azurerm_subnet.public[count.index].id
  network_security_group_id = azurerm_network_security_group.public.id
}

resource "azurerm_subnet_network_security_group_association" "private" {

  count                     = length(azurerm_subnet.private)
  subnet_id                 = azurerm_subnet.private[count.index].id
  network_security_group_id = azurerm_network_security_group.private.id
}

# Azure Private Route Table
resource "azurerm_route_table" "private" {

  name                = "${var.environment}-private-rt"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  tags = {
    Environment = var.environment
  }
}

# AZure Private Route Table association
resource "azurerm_subnet_route_table_association" "private" {

  count          = length(azurerm_subnet.private)
  subnet_id      = azurerm_subnet.private[count.index].id
  route_table_id = azurerm_route_table.private.id
}

# Azure Subnet for ALB
resource "azurerm_subnet" "app_gateway" {

  name                 = "${var.environment}-app-gateway-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [
    var.app_gateway_subnet_cidr
  ]

}