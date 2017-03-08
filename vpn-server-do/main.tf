variable "do_token" {}

variable "region" {
  default = "fra1"
}

variable "size" {
  default = "512mb"
}

variable "ssh_keys" {
  default = []
}

variable "vpn_ipsec_psk" {}

variable "vpn_ipsec_psk_encrypted" {
  default = ""
}

variable "vpn_username" {}

variable "vpn_password" {}

variable "vpn_password_encrypted" {
  default = ""
}

variable "networkconnect_file_location" {
  default = "~/Desktop/VPN.networkconnect"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

data "template_file" "userdata" {
  template = "${file("${path.module}/vpn-setup.sh.tpl")}"

  vars {
    vpn_ipsec_psk = "${var.vpn_ipsec_psk}"
    vpn_username  = "${var.vpn_username}"
    vpn_password  = "${var.vpn_password}"
  }
}

data "template_file" "networkconnect" {
  template = "${file("${path.module}/vpn.networkconnect.tpl")}"

  vars {
    vpn_ipsec_psk_encrypted = "${var.vpn_ipsec_psk_encrypted}"
    vpn_username            = "${var.vpn_username}"
    vpn_password_encrypted  = "${var.vpn_password_encrypted}"
    ip_address              = "${digitalocean_droplet.vpn.ipv4_address}"
  }
}

resource "digitalocean_droplet" "vpn" {
  image     = "ubuntu-16-04-x64"
  name      = "vpn"
  region    = "${var.region}"
  size      = "${var.size}"
  ssh_keys  = "${var.ssh_keys}"
  user_data = "${data.template_file.userdata.rendered}"
}

resource "null_resource" "mac_config_file" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.networkconnect.rendered}\" > ${var.networkconnect_file_location}"
  }
}

output "IP" {
  value = "${digitalocean_droplet.vpn.ipv4_address}"
}
