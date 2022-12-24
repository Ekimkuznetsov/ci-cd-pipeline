output "jenkins_private_ip" {
  description = "The private IP address of the jenkins machine."
  sensitive   = true
  value       = google_compute_instance.jenkins.network_interface.0.network_ip
}

output "jenkins_public_ip" {
  description = "The public IP address of the jenkins machine."
  sensitive   = true
  value       = google_compute_instance.jenkins.network_interface.0.access_config.0.nat_ip 
}