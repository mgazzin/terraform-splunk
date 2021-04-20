# Terraform/ansible cluster environment for Splunk based on KVM
This setup allows you to quickly deploy a set of VMs you can use for a Splunk cluster environment

Prerequisites for this deployment are:

1. Creation of KVM Linux VM template that you can use for multiple deployment
2. Download of Splunk Enterprise and Splunk Universal Forwarder tar files

These items will be used dureing the Terraform deployment and Ansible setup.

For KVM template creation you can use the following guide:

https://www.tecmint.com/create-kvm-virtual-machine-template/

This environment consists of the following VMS:

- clsplkinx1: Splunk indexer #1
- clsplkinx2: Splunk indexer #2
- clsplkcm: Splunk Cluster Master
- clsplksh1: Splunk Search Head #1
- clsplksh2: Splunk Search Head #2
- clsplkdep: Splunk Deployer
- clsplkds: Deployment Server
- clsplkuf: Splunk Universal Forwarder

## Terraform configuration files setup

### KVM VM template

I am using "template-centos83.qcow2" as template.
If you want to create a template with different name, change it in the main.tf files in the followin session:

```
resource "libvirt_volume" "distro-qcow2" {
  count  = var.hosts
  name   = "${var.hostnames[count.index]}.qcow2"
  source = "/var/lib/libvirt/images/template-centos83.qcow2"
  format = "qcow2"
}
```

### Terraform template files

I am using:

- network_config.tpl
- user_data.tpl

If you have a different network space address, change network_config.tpl:

```
ethernets:
    ${interface}:
        dhcp4: true
        gateway4: 192.168.1.1
        match:
            macaddress: ${mac_addr}
        nameservers:
            addresses:
            - 192.168.1.1
        set-name: ${interface}
version: 2
```

### SSH public key

For each of the following directories:

- indexer-layer/ssh
- search-head-layer/ssh
- forwarder-layer/ssh

Create a link to you SSH public key.
In my case I am using it in main.tf with name 'id_ed25519.pub':

```
user_data = templatefile("${path.module}/templates/user_data.tpl", {
    host_name = var.hostnames[count.index]
    auth_key  = file("${path.module}/ssh/id_ed25519.pub")
})  
```

Relace this path name if it is necessary.

## Terraform Deployment

For each of the following directories:

- indexer-layer
- search-head-layer
- forwarder-layer

CD into these directories and aexecute the following commands:

```
> terraform init
> terraform plan
> terraform apply
```


## Splunk configuration deployment with Ansible

### Download splunk

Please download your own version of Splunk Enterprise and Splunk Forwarder and put with the following names in 'ansible' directory:

- splunk-Linux-x86_64.tgz
- splunkforwarder-Linux-x86_64.tgz

### Prepare environment

In order to prepare environment, execute the following playbook:

```
cd ansible
ansible-playbook -i ansible_inventory.yaml -K prepare-environment.playbook
```

### Ansible playbook

Execute the following playbook for Splunk installation:

```
cd ansible
ansible-playbook -i ansible_inventory.yaml -K install-splunk.playbook
```

### Apply firewall rules

Open firewall ports with the following playbook:

```
ansible-playbook -i ansible_inventory.yaml -K firewall.playbook
```
