resource "google_compute_instance" "jenkins" {
  name         = "jenkins"
  machine_type = "e2-medium"
  tags = "public"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
    metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
  }
}
