# ==================================================
# Terraform & Providers
# ==================================================
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.56.0"
    }
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}


resource "azurerm_template_deployment" "pgsql_cluster" {
    name                              = var.pgsql.name
    resource_group_name               = var.pgsql.resource_group
    template_body                     = file("${path.module}/arm/hyperscale-pgsql.json")

    parameters = {
        serverGroup                   = var.pgsql.serverGroup
        administratorLogin            = var.pgsql.administratorLogin
        location                      = var.pgsql.location
        administratorLoginPassword    = var.pgsql.administratorLoginPassword
        coordName                     = var.pgsql.coordName
        coordinatorVcores             = var.pgsql.coordinatorVcores
        coordinatorStorageSizeMB      = var.pgsql.coordinatorStorageSizeMB
        workerVcores                  = var.pgsql.workerVcores
        workerStorageSizeMB           = var.pgsql.workerStorageSizeMB
        #numWorkers                    = var.pgsql_worker_count
    }

     deployment_mode = "Incremental"
     depends_on = []  
}

resource "azurerm_template_deployment" "terraform_client_firewall_rule" {
  for_each                          = var.ip_whitelist

  name                              = "tfclients"
  resource_group_name               = var.pgsql.resource_group
  template_body                     = file("${path.module}/arm/hyperscale-pgsql-firewallrule.json")

  parameters = {
      coordName                     = var.pgsql.coordName
      firewallRulesName             = each.key
      firewallRulesStartIPAddress   = each.value.ip
      firewallRulesEndIPAddress     = each.value.ip
  }
  deployment_mode = "Incremental"
  depends_on = [
      azurerm_template_deployment.pgsql_cluster
  ]
}
