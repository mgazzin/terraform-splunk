#cloud-config
#vim: syntax=yaml
hostname: ${host_name}
manage_etc_hosts: true
users:
  - name: splunk
    groups: wheel, docker
    ssh_authorized_keys:
      - ${auth_key}
ssh_pwauth: true
disable_root: false
chpasswd:
  list: |
    splunk:Splunk.2021
  expire: false
runcmd:
 - hostnamectl set-hostname --static ${host_name}
 - yum update -y
