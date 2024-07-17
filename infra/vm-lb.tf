resource "openstack_compute_instance_v2" "tf_lb" {
  name              = "tf-lb"
  image_id          = data.openstack_images_image_v2.srv_nginx_ubuntu1804.id
  flavor_id         = data.openstack_compute_flavor_v2.small.id
  key_pair          = var.key_name
  security_groups   = [openstack_compute_secgroup_v2.tf_sg_lb.name]
  availability_zone = "nodos-amd-2022"

  user_data = templatefile("${path.module}/templates/vm-lb.init.sh", {
    app_ip = openstack_compute_instance_v2.tf_app.network.0.fixed_ip_v4
  })

  network {
    name = openstack_networking_network_v2.tf_net.name
  }

  depends_on = [
    openstack_networking_subnet_v2.tf_subnet,
  ]
}

resource "openstack_compute_floatingip_associate_v2" "tf_lb_fip" {
  floating_ip = openstack_networking_floatingip_v2.tf_lb_fip.address
  instance_id = openstack_compute_instance_v2.tf_lb.id
}
