## Kubernetes cluster deployment on a VMware vCloud platform

This module intended to add workers to existing K8s cluster, to support extending clusters deployed from this module:
https://github.com/werton13/tf-vcloud-k8s

deploy Kubernetes cluster inside a tenant on standard VMware vCloud platform.
It  creates a set of virtual machines for K8s control and data plane, make their preparation, bootstrap Kubernetes cluster, add all defined members and install a set of Kubernetes addons.

All customusation and configuration performing by a dedicated Ansible playbook: https://github.com/werton13/k8s-kubeadm-ansible.git which was  created specifically for this project(and for the parallel vsphere project) and embedded into module variable.



#### WHAT IT WILL DO:

During this terraform code execution will be perormed:
 - creation a set of virtual machines for:
   - n worker nodes - as many as defined in input variables

#### HOW TO USE:

<b>To use this module you have to: </b>
suppose vcloud infastructure for K8s cluster s already deployed and configured during initial cluster deployment

- create new terraform project
- copy variables.tf file from this repository into your new project
- copy example.tfvars and modify it according your environment
- create main.tf file and fill it the following way:


```hcl
provider "vcd" {
  user                 = var.vcloud.admin
  password             = var.vcloud.admin_pwd
  org                  = var.vcloud.orgname
  vdc                  = var.vcloud.vdc
  url                  = var.vcloud.server_fqdn
  allow_unverified_ssl = var.vcloud.allow_unverified_ssl
  max_retry_timeout    = var.vcloud.max_retry_timeout
}

module "tf-vcloud-k8s_add-workers" {
  source = "github.com/werton13/tf-vcloud-k8s_add-workers?ref=main"
  project      = var.project
  vcloud       = var.vcloud
  ip_plan      = var.ip_plan
  vms_config   = var.vms_config
  disks_config = var.disks_config
  os_config    = var.os_config
  ansible      = var.ansible
  kubernetes   = var.kubernetes
  versions     = var.versions
  obs_config   = var.obs_config

}

```
<details>
  <summary><b>Default values</b></summary>

```  
vcloud_allow_unverified_ssl = "true"
vcloud_max_retry_timeout    = "240"
under construction ...
```
 
</details>