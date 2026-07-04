output "public_ip" {
  value     = oci_core_instance.server.public_ip
  sensitive = true
}

output "instance_id" {
  value = oci_core_instance.server.id
}
