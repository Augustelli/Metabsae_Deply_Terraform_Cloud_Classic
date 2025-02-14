resource "openstack_compute_secgroup_v2" "tf_sg_bastion" {
  name        = "tf_sg_bastion"
  description = "tf_sg_bastion"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "icmp"
    from_port   = -1
    to_port     = -1
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "tf_sg_lb" {
  name        = "tf_sg_lb"
  description = "tf_sg_lb"

  rule {
    from_group_id = openstack_compute_secgroup_v2.tf_sg_bastion.id
    from_port     = -1
    to_port       = -1
    ip_protocol   = "icmp"
  }
  rule {
    from_group_id = openstack_compute_secgroup_v2.tf_sg_bastion.id
    from_port     = 22
    to_port       = 22
    ip_protocol   = "tcp"
  }
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "tf_sg_app" {
  name        = "tf_sg_app"
  description = "tf_sg_app"

  rule {
    from_group_id = openstack_compute_secgroup_v2.tf_sg_bastion.id
    from_port     = -1
    to_port       = -1
    ip_protocol   = "icmp"
  }
  rule {
    from_group_id = openstack_compute_secgroup_v2.tf_sg_bastion.id
    from_port     = 22
    to_port       = 22
    ip_protocol   = "tcp"
  }
  rule {
    from_group_id = openstack_compute_secgroup_v2.tf_sg_lb.id
    from_port     = 3000
    to_port       = 3000
    ip_protocol   = "tcp"
  }
}

resource "openstack_compute_secgroup_v2" "tf_sg_db" {
  name        = "tf_sg_db"
  description = "tf_sg_db"

  rule {
    from_group_id = openstack_compute_secgroup_v2.tf_sg_bastion.id
    from_port     = -1
    to_port       = -1
    ip_protocol   = "icmp"
  }
  rule {
    from_group_id = openstack_compute_secgroup_v2.tf_sg_bastion.id
    from_port     = 22
    to_port       = 22
    ip_protocol   = "tcp"
  }
  rule {
    from_group_id = openstack_compute_secgroup_v2.tf_sg_app.id
    from_port     = 3306
    to_port       = 3306
    ip_protocol   = "tcp"
  }
}

