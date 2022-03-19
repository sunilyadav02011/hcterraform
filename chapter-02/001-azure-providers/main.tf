terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.98.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
}

resource "azurerm_resource_group" "sk-test" {
    name = "sktest-rg"
    location = "eastus"
}


module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.sk-test.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["linsimplevmips01"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  vm_size= "Standard_B1ms"
  depends_on = [azurerm_resource_group.sk-test]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.sk-test.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["sktest01-subnet"]

  depends_on = [azurerm_resource_group.sk-test]
}


output "linux_vm_public_name" {
  value = module.linuxservers.public_ip_dns_name
}