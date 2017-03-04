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

variable "vpn_username" {}

variable "vpn_password" {}

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

resource "digitalocean_droplet" "vpn" {
  image     = "ubuntu-16-04-x64"
  name      = "vpn"
  region    = "${var.region}"
  size      = "${var.size}"
  ssh_keys  = "${var.ssh_keys}"
  user_data = "${data.template_file.userdata.rendered}"
}

output "IP" {
  value = "${digitalocean_droplet.vpn.ipv4_address}"
}
