
enable_telemetry    = true
resource_group_name = "lumen-aks-rg-03"
location            = "EastUS2"
name                = "aks-02"
kubernetes_version  = "1.28"
node_cidr           = "10.31.0.0/16"
pod_cidr            = "192.168.0.0/16"
node_pools = {
  workload = {
    name                 = "workload"
    vm_size              = "Standard_D2d_v5"
    orchestrator_version = "1.28"
    max_count            = 110
    min_count            = 2
    os_sku               = "Ubuntu"
    mode                 = "User"
  }
}
keyvault_name                                 = "lumen-aks-kv-03"
object_id                                     = "08afb591-fb58-46c1-b797-76688967a5cf"
tenant_id                                     = "680f956b-1eaf-4bb1-a703-24b289ea568f"
storage_account_name                          = "lumenstorage1234"
domain_name                                   = "privatelink.wvd.microsoft.com"
virtual_desktop_host_pool_load_balancer_type  = "DepthFirst"
virtual_desktop_host_pool_name                = "avdhostpool-1"
virtual_desktop_host_pool_type                = "Pooled"
virtual_desktop_application_group_name        = "applicationgroup-1"
virtual_desktop_application_group_type        = "Desktop"
virtual_desktop_workspace_name                = "AVDWorkspace"
operationalinsights_workspace_name            = "OperationalInsightsWorkspaceLumen"
virtual_desktop_host_pool_resource_group_name = "AVD"
virtual_desktop_host_pool_location            = "East US"