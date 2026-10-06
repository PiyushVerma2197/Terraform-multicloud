# Azure Public IP
resource "azurerm_public_ip" "app_gateway" {

  name                = "${var.environment}-app-gateway-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
  }
}

#Azure Application Load Balancer
resource "azurerm_application_gateway" "app" {

  name                = "${var.environment}-app-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 3
  }

  gateway_ip_configuration {
    name      = "app-gateway-ip-config"
    subnet_id = azurerm_subnet.app_gateway.id
  }

  frontend_ip_configuration {
    name                 = "public-frontend"
    public_ip_address_id = azurerm_public_ip.app_gateway.id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  backend_address_pool {
    name = "app-backend-pool"
  }

  backend_http_settings {
    name                  = "app-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {

    name                           = "http-listener"
    frontend_ip_configuration_name = "public-frontend"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "app-routing-rule"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "app-backend-pool"
    backend_http_settings_name = "app-http-settings"
  }

  tags = {
    Environment = var.environment
  }
}