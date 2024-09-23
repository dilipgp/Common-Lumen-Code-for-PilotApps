enable_telemetry                                            = true
resource_group_name                                         = "AVD"
location                                                    = "East US"
virtual_network                                             = "VNET03" 
subnets = {
  subnet1 = { name = "sub1", address_prefix = "10.0.1.0/24" }
  subnet2 = { name = "sub2", address_prefix = "10.0.2.0/24" }
  subnet3 = { name = "sub3", address_prefix = "10.0.3.0/24" }
  subnet4 = { name = "sub4", address_prefix = "10.0.4.0/24" }
}
nsg_name                                                    = "vm001-nsg"
keyvault_name                                               = "avd-domainjoin-for-lumen"
tenant_id                                                   = "c925fe9d-30b1-4191-acbf-4109845df16f"
storage_accont_name                                         = "devopslumen01"
virtual_desktop_host_pool_resource_group_name               = "AVD"
virtual_desktop_host_pool_location                          = "East US"
virtual_desktop_host_pool_load_balancer_type                = "Breadth-first"
virtual_desktop_host_pool_maximum_sessions_allowed          = "5"
virtual_desktop_host_pool_start_vm_on_connect               = "true"
virtual_desktop_host_pool_name                              = "AVD-Host01"
virtual_desktop_host_pool_type                              = "Pooled"
virtual_desktop_host_pool_custom_rdp_properties             = "drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1"
virtual_desktop_application_group_type                      = "RemoteApp"
#virtual_desktop_application_group_type                      = "Desktop"
friendly_name                                               = "App"
#friendly_name                                               = "DesktopGroup"
virtual_desktop_application_group_name                      = "App"
#virtual_desktop_application_group_name                      = "Desktopgroup"
virtual_desktop_workspace_name                              = "Prod-Workload"

