output "public_ip_jump_host" {
  description = "Public IP của Jump Host để SSH"
  value       = module.ec2.public_ip_jump_host
}

output "private_ip_app_server" {
  description = "Private IP của App Server"
  value       = module.ec2.private_ip_app_server
}