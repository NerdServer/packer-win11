
packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "win11" {
  additional_iso_files {
    device   = "ide3"
    iso_file = "ISO:iso/win11Autounattend.iso"
    unmount  = true
  }
  bios         = "seabios"
  boot_wait    = "${var.boot_wait}"
  communicator = "winrm"
  cores        = "${var.numvcpus}"
  disks {
    disk_size    = "50G"
    storage_pool = "pve-iscsi-lun0"
    type         = "virtio"
  }
  insecure_skip_tls_verify = "true"
  iso_checksum             = "${var.iso_checksum}"
  iso_file                 = "${var.iso_file}"
  memory                   = "${var.memsize}"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  node             = "${var.node}"
  proxmox_url      = "${var.proxmox_url}"
  ssh_password     = "${var.winrm_password}"
  token            = "${var.token}"
  username         = "${var.username}"
  vm_name          = "${var.vm_name}"
  winrm_insecure   = true
  winrm_password   = "${var.winrm_password}"
  winrm_timeout    = "4h"
  winrm_use_ssl    = true
  winrm_username   = "${var.winrm_username}"
  vm_id            = "9002"
}

build {
  sources = ["source.proxmox-iso.win11"]

  provisioner "powershell" {
    scripts = ["scripts/setup.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/win-update.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/win-update.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/cleanup.ps1"]
  }

}



##Variables
variable "boot_wait" {
  type    = string
  default = null
}

variable "iso_checksum" {
  type    = string
  default = null
}

variable "iso_file" {
  type    = string
}


variable "memsize" {
  type    = string
}

variable "node" {
  type    = string
}

variable "numvcpus" {
  type    = string
}

variable "proxmox_url" {
  type    = string
}

variable "token" {
  type    = string
}

variable "username" {
  type    = string
}

variable "vm_name" {
  type    = string
}

variable "winrm_password" {
  type    = string
}

variable "winrm_username" {
  type    = string
}
