locals {
    adminuser = "adminuser"
    appvserveradminusername = "appvserveruser"
    domainname = "ditclouds.com"
    oupath = "OU=AVD-Hosts,DC=ditclouds,DC=com"
    domainusername = "adminuser"
    virtualmachinename = "vdvmlumen"
    virtual_network_name = "example-network"
    subnet_image_name         = "vd-snet-image-n-mgmt-avd-poc-cus-01"
    subnet_personal_hostpool_name = "vd-snet-personal-wklds-avd-poc-cus-01"
    subnet_pooled_hootpool_name = "snet-pool-wklds-avd-poc-cus-01"
    subnet_bastion_name = "AzureBastionSubnet"
    subnet_pe_name = "vd-snet-pe-avd-poc-cus-01"
    resource_group_name_vnet = "lumen-avd-rg-03"
    resource_group_name_shared = "AD"
    resource_group_name_avd = "Vnet01"
    resource_group_name_dns = "for-DNSZone"

    nsg_image_name = "vd-nsg-image-avd-poc-cus-01"
    nsg_personal_hostpool_name = "vd-nsg-personal-wklds-avd-poc-cus-01"
    nsg_pooled_hostpool_name = "vd-nsg-pool-wklds-avd-poc-cus-01"
    nsg_bastion_name = "AzureBastionSubnet"
    nsg_pe_name = "vd-nsg-pe-avd-poc-cus-01"

    avd_rg_name = "Vnet01"
    avd_rg_shared_name = "Vnet01"

    // DNS RG Name
    dns_rg_name = "for-DNSZone"

    //Hostpool1
    virtual_desktop_host_pool1_load_balancer_type = "BreadthFirst"
    virtual_desktop_host_pool1_name = "avdhostpool-1"
    virtual_desktop_host_pool1_type = "Pooled"
    virtual_desktop_host_pool1_maximum_sessions_allowed = 3
    virtual_desktop_host_pool1_start_vm_on_connect = true
    virtual_desktop_host_pool1_preferred_app_group_type = "RailApplications"

    //Hostpool2
    virtual_desktop_host_pool2_load_balancer_type = "BreadthFirst"
    virtual_desktop_host_pool2_name = "avdhostpool-2"
    virtual_desktop_host_pool2_type = "Pooled"
    virtual_desktop_host_pool2_maximum_sessions_allowed = 3
    virtual_desktop_host_pool2_start_vm_on_connect = true
    virtual_desktop_host_pool2_preferred_app_group_type = "RailApplications"

    //Hostpool3
    virtual_desktop_host_pool3_load_balancer_type = "BreadthFirst"
    virtual_desktop_host_pool3_name = "avdhostpool-3"
    virtual_desktop_host_pool3_type = "Personal"
    virtual_desktop_host_pool3_maximum_sessions_allowed = 1
    virtual_desktop_host_pool3_start_vm_on_connect = true
    virtual_desktop_host_pool3_preferred_app_group_type = "Desktop"

    //Hostpool4
    virtual_desktop_host_pool4_load_balancer_type = "BreadthFirst"
    virtual_desktop_host_pool4_name = "avdhostpool-4"
    virtual_desktop_host_pool4_type = "Personal"
    virtual_desktop_host_pool4_maximum_sessions_allowed = 1
    virtual_desktop_host_pool4_start_vm_on_connect = true
    virtual_desktop_host_pool4_preferred_app_group_type = "Desktop"


    // ApplicationGroups - Pooled - HP1
    app1_application_group_name = "appgroup-1"

    app2_application_group_name = "appgroup-2"

    app3_application_group_name = "appgroup-3"

    app4_application_group_name = "appgroup-4"

    app5_application_group_name = "appgroup-5"

    // ApplicationGroups - Pooled - HP2
    app6_application_group_name = "appgroup-6"

    app7_application_group_name = "appgroup-7"

    app8_application_group_name = "appgroup-8"

    app9_application_group_name = "appgroup-9"

    app10_application_group_name = "appgroup-10"

    // Desktopgroup - Personal - HP3
    desktop_group1_name = "desktopgroup-1"

    // Desktopgroup - Personal - HP4
    desktop_group2_name = "desktopgroup-2"

    // WSname
    virtual_desktop_workspace_name                = "AVDWorkspace"


    // Existing Keyvault
    keyvault_name_existing = "avd-domainjoin-for-lumen"
    secretnamedjusername = "domain-join-account-username"
    secretnamedjpassword = "domain-join-account-password"

    // storage
    storage_account_name = "vdavdstorageaccount"
    storageblobpename = "vdavdstorageblobpe"
    storagefilepename = "vdavdstoragefilepe"
    diagstoragename = "vddiagstoragename"
    fsstoragename = "vdfsstoragename"
    artifactstoragename = "vdartifactstoragename"
    filesharename = "vdlumenfilesharename"

    // AppV  3 VM Names
    appv_vm1_name = "appv-vm1"
    appv_vm2_name = "appv-vm2"
    appv_vm3_name = "appv-vm3"

    // sku size of 3 Vms
    appv_vm1_sku_size = "Standard_D8lds_v5"
    appv_vm2_sku_size = "Standard_D8ls_v5"
    appv_vm3_sku_size = "Standard_D8ls_v5"

    // AppV  3 VM data disk sizes
    appv_vm1_data_disk_size = [
      { size_gb = 100, type = "Premium_LRS", name = "appv-vm1-disk1", lun = 0 },
      { size_gb = 100, type = "Premium_LRS", name = "appv-vm1-disk2", lun = 1 },
      { size_gb = 50, type = "Premium_LRS", name = "appv-vm1-disk3", lun = 2 },
      { size_gb = 50, type = "Premium_LRS", name = "appv-vm1-disk4", lun = 3 }
      ]
    appv_vm2_data_disk_size = [
      { size_gb = 1024, type = "Premium_LRS", name = "appv-vm2-disk1", lun = 0 }
      ]
    appv_vm3_data_disk_size = [
      { size_gb = 1024, type = "Premium_LRS", name = "appv-vm3-disk1", lun = 0 }
      ]

    // AppV image Sku
    appv_sku = "2022-datacenter"
    appv_offer = "WindowsServer"
    appv_publisher = "MicrosoftWindowsServer"
    appv_version = "latest"

    // key Vault name
    keyvault_name = "vdavdkey0023"

    // Diag Workspace Name
    operationalinsights_workspace_name            = "OperationalInsights02939"

    domain_name_avd = "privatelink.wvd.microsoft.com"
    }