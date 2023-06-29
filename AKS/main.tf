resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_storage_account" "tfstateale" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.Teste-tf.name
  location                 = azurerm_resource_group.Teste-tf.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    infra = "devops"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstateale.name
  container_access_type = "private"
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstateale.name

  sensitive = true
}

# Configure cluster AKS
resource "azurerm_kubernetes_cluster" "Teste-tf" {
  name                         = "automacao_aks"
  resource_group_name          = azurerm_resource_group.Teste-tf.name
  location                     = azurerm_resource_group.Teste-tf.location
  dns_prefix                   = "dns-teste"
  kubernetes_version           = ">=1.0.0" #Verificar sempre se as aplicações ou algum recurso tem alguma limitação de versão

default_node_pool {
  name                         = "automacaoaks"
  node_count                   = "2"
  vm_size                      = "Standard_D2_v2"
  zones                         = [1,2]
  }

  identity {
    type = "SystemAssigned"
  }  

  tags = {
    Infra = "devops"
  }
}
#Configure o container registrer
resource "azurerm_container_registry" "acr" {
  name                = "testeAcr"
  resource_group_name = azurerm_resource_group.Teste-tf.name
  location            = azurerm_resource_group.Teste-tf.location
  sku                 = "Premium"
  admin_enabled       = false
 #Replicação geográfica
  #georeplications {
   # location                = "East US"
    #zone_redundancy_enabled = true
    #tags                    = {}
  #}
  #georeplications {
   # location                = "North Europe"
    #zone_redundancy_enabled = true
    #tags                    = {}
  #}
}
#resource "azurerm_role_assignment" "example" {
 # principal_id                     = azurerm_kubernetes_cluster.example.kubelet_identity[0].object_id
  #role_definition_name             = "AcrPull"
  #scope                            = azurerm_container_registry.example.id
  #skip_service_principal_aad_check = true
#}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.Teste-tf.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.Teste-tf.kube_config_raw
  sensitive = true
}