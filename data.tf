data "vcd_catalog" "vcd_dp_linux" {
    org  = var.vcloud.orgname
    name = var.vcloud.catalogname
}

data "vcd_edgegateway" "egw" {
  name = var.vcloud.edgegw
}

data "template_file" "cloudinit_worker_node" {
template = file("${path.module}/templates/userdata_w.yaml")
  vars = {

    vm_user_name        = var.os_config.vm_user_name
    vm_user_password    = var.os_config.vm_user_password
    vm_user_displayname = var.os_config.vm_user_displayname     
    vm_user_ssh_key     = var.os_config.vm_user_ssh_key
    ansible_ssh_pass    = var.os_config.ansible_ssh_pass

    master_pref         = "${var.project.owner_org}-${var.project.name}-${var.project.env_name}-mst" 
    worker_pref         = "${var.project.owner_org}-${var.project.name}-${var.project.env_name}-wrk"

    workers_count       = var.vms_config.workers.vm_count
    masters_count       = var.vms_config.masters.vm_count

    master0_ip          = "${cidrhost(var.os_config.vm_ip_cidr,4)}"

    hosts_entry0        = "${var.vcloud.server_ip}  ${split("/", var.vcloud.server_fqdn)[2]}"
    #hosts_entry1        = "${cidrhost(var.os_config.vm_ip_cidr,tonumber(var.ip_plan.dvm))}  ${var.vms.dvm.pref}"
    hosts_entry1        = "${cidrhost(var.os_config.vm_ip_cidr,tonumber(var.ip_plan.dvm))}  dvm"
  }
}