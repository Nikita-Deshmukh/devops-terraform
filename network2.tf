# Create the networkb
resource "google_compute_network" "networkb" {
  name                    = "networkb"
  auto_create_subnetworks = "false"
}

# Create networkcsubnet-asia subnetwork
resource "google_compute_subnetwork" "networkcsubnet-asia" {
  name          = "networkcsubnet-asia"
  region        = "asia-south1"
  network       = "${google_compute_network.networkb.self_link}"
  ip_cidr_range = "111.130.0.0/20"
}

# Add a firewall rule to allow HTTP, SSH, and RDP traffic on network2
resource "google_compute_firewall" "networkb-allow-http-ssh-rdp-icmp" {
  name    = "networkb-allow-http-ssh-rdp-icmp"
  network = "${google_compute_network.networkb.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }

  allow {
    protocol = "icmp"
  }
}

# Add the networkc-us-vm instance1
module "networkc-asia-vm1" {
  source              = "./instance"
  instance_name       = "networkc-asia-vm1"
  instance_zone       = "asia-south1-a"
  instance_subnetwork = "${google_compute_subnetwork.networkcsubnet-asia.self_link}"
}

# Add the networkc-us-vm instance2
module "networkc-asia-vm2" {
  source              = "./instance"
  instance_name       = "networkc-asia-vm2"
  instance_zone       = "asia-south1-b"
  instance_subnetwork = "${google_compute_subnetwork.networkcsubnet-asia.self_link}"
}