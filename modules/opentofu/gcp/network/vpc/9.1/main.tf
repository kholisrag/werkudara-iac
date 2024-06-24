module "gcp_network_vpc" {
  source  = "terraform-google-modules/network/google"
  version = "9.1.0"

  project_id                                = var.project_id
  network_name                              = var.network_name
  routing_mode                              = var.routing_mode
  shared_vpc_host                           = var.shared_vpc_host
  subnets                                   = var.subnets
  secondary_ranges                          = var.secondary_ranges
  routes                                    = var.routes
  firewall_rules                            = var.firewall_rules
  delete_default_internet_gateway_routes    = var.delete_default_internet_gateway_routes
  description                               = var.description
  auto_create_subnetworks                   = var.auto_create_subnetworks
  mtu                                       = var.mtu
  ingress_rules                             = var.ingress_rules
  egress_rules                              = var.egress_rules
  enable_ipv6_ula                           = var.enable_ipv6_ula
  internal_ipv6_range                       = var.internal_ipv6_range
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
}
