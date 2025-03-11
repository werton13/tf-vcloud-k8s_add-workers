resource "vcd_vm_internal_disk" "wrk_data1_disk" {
  depends_on       = [vcd_vapp_vm.k8s_workers_vms]
  count           = var.vms_config.workers.vm_count
  #count = 2
  vapp_name       = var.vcloud.vapp_name
  bus_type        = var.disks_config.diskw1.bus_type
  size_in_mb      = var.disks_config.diskw1.sizegb * 1024
  bus_number      = var.disks_config.diskw1.bus_num
  unit_number     = var.disks_config.diskw1.unit_num
  vm_name = "${var.project.owner_org}-${var.project.name}-${var.project.env_name}-wrk-${format("%02s", (var.vms_config.workers.vm_exist + count.index + 1))}"
}

resource "vcd_vm_internal_disk" "wrk_data2_disk" {
  depends_on      = [vcd_vapp_vm.k8s_workers_vms]
  count           = var.vms_config.workers.vm_count
  #count = 2
  vapp_name       = var.vcloud.vapp_name
  bus_type        = var.disks_config.diskw2.bus_type
  size_in_mb      = var.disks_config.diskw2.sizegb * 1024
  bus_number      = var.disks_config.diskw2.bus_num
  unit_number     = var.disks_config.diskw2.unit_num
  vm_name = "${var.project.owner_org}-${var.project.name}-${var.project.env_name}-wrk-${format("%02s", (var.vms_config.workers.vm_exist + count.index + 1))}"
}


resource "vcd_vapp_vm" "k8s_workers_vms" {

#  depends_on       = [vcd_vapp.k8s_mgmt_vapp,
#                      vcd_vapp_org_network.vappOrgNet]
  
  vapp_name        = var.vcloud.vapp_name #vcd_vapp.k8s_mgmt_vapp.name
  name             = "${var.project.owner_org}-${var.project.name}-${var.project.env_name}-wrk-${format("%02s", (var.vms_config.workers.vm_exist + count.index + 1))}"
  count            = var.vms_config.workers.vm_count

  catalog_name     = data.vcd_catalog.vcd_dp_linux.name
  template_name    = var.vcloud.vm_template_name
  hardware_version = "vmx-15" #Test version    
  cpus             = var.vms_config.workers.vm_cpu_count
  memory           = var.vms_config.workers.vm_ram_size
  cpu_cores        = 1

  network {
    type               = "org"
    name               = var.vcloud.orgvnet_name
    ip_allocation_mode = "MANUAL"
    adapter_type       = "VMXNET3"
    ip                 = "${cidrhost(var.os_config.vm_ip_cidr, (count.index+tonumber(var.ip_plan.w_node)+tonumber(var.vms_config.workers.vm_exist)))}"
  }
  override_template_disk {
    size_in_mb      = var.disks_config.osdisk.sizegb * 1024
    bus_type        = var.disks_config.osdisk.bus_type
    bus_number      = var.disks_config.osdisk.bus_num
    unit_number     = var.disks_config.osdisk.unit_num
    # storage_profile = var.mod_system_disk_storage_profile
  }

  guest_properties = {
    "instance-id" = "${var.project.owner_org}-${var.project.name}-${var.project.env_name}-wrk-${format("%02s", (var.vms_config.workers.vm_exist + count.index + 1))}"
    "hostname"    = "${var.project.owner_org}-${var.project.name}-${var.project.env_name}-wrk-${format("%02s", (var.vms_config.workers.vm_exist + count.index + 1))}"
    "user-data"   = "${base64encode(data.template_file.cloudinit_worker_node.rendered)}"
  }

}


