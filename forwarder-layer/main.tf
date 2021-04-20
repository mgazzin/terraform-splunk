terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "distro-qcow2" {
  count  = var.hosts
  name   = "${var.hostnames[count.index]}.qcow2"
  source = "/var/lib/libvirt/images/template-centos83.qcow2"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" { 
  count     = var.hosts
  name      = "${var.hostnames[count.index]}.iso"
  user_data = templatefile("${path.module}/templates/user_data.tpl", {
      host_name = var.hostnames[count.index]
      auth_key  = file("${path.module}/ssh/id_ed25519.pub")
  })  
  network_config =   templatefile("${path.module}/templates/network_config.tpl", {
     interface = var.interface
     mac_addr = var.macs[count.index]
  })
}

resource "libvirt_domain" "domain-distro" {
  count  = var.hosts
  name   = var.hostnames[count.index]
  memory = var.memory
  vcpu   = var.vcpu  
  cloudinit = element(libvirt_cloudinit_disk.commoninit.*.id, count.index)
  
  network_interface {
      network_name   = "host-bridge"
      wait_for_lease = true
      mac            = var.macs[count.index]
      hostname       = var.hostnames[count.index]
  }  

  console {
      type        = "pty"
      target_port = "0"
      target_type = "serial"
  }  

  console {
      type        = "pty"
      target_port = "1"
      target_type = "virtio"
  }  

  disk {
      volume_id = element(libvirt_volume.distro-qcow2.*.id, count.index)
  }
  
}
