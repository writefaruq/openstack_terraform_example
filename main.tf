# Configure the OpenStack Provider
provider "openstack" {
    user_name  = "admin"
    tenant_name = "admin"
    password  = "<PASS>"
    auth_url  = "http://172.25.250.12:5000/v2.0"
}

# Create a web server

resource "openstack_compute_keypair_v2" "terraform" {
  name       = "terraform"
  public_key = "${file("${var.ssh_key_file}.pub")}"
}


resource "openstack_compute_instance_v2" "terraform" {
  name            = "terraform"
  image_name      = "small"
  flavor_name     = "m2.small"
  key_pair        = "${openstack_compute_keypair_v2.terraform.name}"
  security_groups = ["default"]
  floating_ip     = "172.25.250.27"

  network {
    uuid = "a0d6478b-aad8-4b50-b398-48b7637e80ad"
  }

  provisioner "remote-exec" {
    connection {
      user     = "cloud-user"
      private_key =  "${file(var.ssh_key_file)}"
      #agent = false
    }

    inline = [
      "sudo yum -y update",
      "sudo yum -y install httpd",
      "sudo service httpd start",
    ]
  }


}
