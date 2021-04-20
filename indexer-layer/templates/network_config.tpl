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
