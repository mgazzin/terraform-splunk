variable "hosts" {
  type = number
  default = 3
}

variable "hostnames" {
  type = list
  default = ["clsplkinx1", "clsplkinx2", "clsplkcm"]
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
  default = ["52:54:00:1D:3E:4B", "52:54:00:E7:A5:C3", "52:54:00:99:EB:18"]
}
