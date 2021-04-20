variable "hosts" {
  type = number
  default = 2
}

variable "hostnames" {
  type = list
  default = ["clsplkds", "clsplkuf"]
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
  default = ["52:54:00:EF:A5:EE", "52:54:00:BB:AE:6B"]
}
