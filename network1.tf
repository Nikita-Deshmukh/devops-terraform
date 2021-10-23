
 # Create the networka
resource "google_compute_network" "networka" {
  name                    = "networka"
  auto_create_subnetworks = "false"
}

#Create Subneta
resource "google_compute_subnetwork" "subneta" {
 name          = "subneta"
 ip_cidr_range = "168.130.0.0/20"
 network       = "${google_compute_network.networka.self_link}"
 region      = "us-central1"
}

#Create Subnetb
resource "google_compute_subnetwork" "subnetb" {
 name          = "subnetb"
 ip_cidr_range = "10.130.0.0/24"
 network       = "${google_compute_network.networka.self_link}"
 region      = "europe-west1"
}

# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on network1
resource "google_compute_firewall" "network1_allow_http_ssh_rdp_icmp" {
  name    = "network1-allow-http-ssh-rdp-icmp"
  network = "${google_compute_network.networka.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }

  allow {
    protocol = "icmp"
  }
}

# Create the subnetworka-us-vm instance
module "networka-us-vm" {
  source              = "./instance"
  instance_name       = "networka-us-vm"
  instance_zone       = "us-central1-a"
  instance_subnetwork = "${google_compute_subnetwork.subneta.self_link}"
}

# Create the subnetworkb-eu-vm" instance
module "networka-eu-vm" {
  source              = "./instance"
  instance_name       = "networka-eu-vm"
  instance_zone       = "europe-west1-c"
  instance_subnetwork = "${google_compute_subnetwork.subnetb.self_link}"
}