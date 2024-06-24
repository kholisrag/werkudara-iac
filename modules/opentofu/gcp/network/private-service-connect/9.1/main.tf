module "gcp_network_private_service_connect" {
  source  = "terraform-google-modules/network/google//modules/private-service-connect"
  version = "9.1.0"

  project_id                   = var.project_id
  network_self_link            = var.network_self_link
  dns_code                     = var.dns_code
  private_service_connect_name = var.private_service_connect_name
  private_service_connect_ip   = var.private_service_connect_ip
  forwarding_rule_name         = var.forwarding_rule_name
  forwarding_rule_target       = var.forwarding_rule_target
  service_directory_namespace  = var.service_directory_namespace
  service_directory_region     = var.service_directory_region
}
