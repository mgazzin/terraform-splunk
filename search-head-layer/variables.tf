variable "hosts" {
  type = number
  default = 3
}

variable "hostnames" {
  type = list
  default = ["clsplksh1", "clsplksh2", "clsplkdep"]
}

variable "interface" {
  type = string
  default = "enp0s1"
}

variable "memory" {
  type = string
  default = "2048"
}

variable "vcpu" {
  type = number
  default = 1
}

variable "macs" {
  type = list
  default = ["52:54:00:50:99:C5", "52:54:00:0E:87:BE", "52:54:00:9D:90:38"]
}
