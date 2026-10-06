resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.environment}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = "${var.environment}-aks"
  kubernetes_version  = var.aks_kubernetes_version

  default_node_pool {
    name           = "system"
    vm_size        = var.aks_node_vm_size
    node_count     = var.aks_node_count
    vnet_subnet_id = azurerm_subnet.private[0].id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = var.environment
  }
}