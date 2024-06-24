module "gcp_project_factory_shared_vpc_access" {
  source  = "terraform-google-modules/project-factory/google//modules/shared_vpc_access"
  version = "15.0.1"

  host_project_id                    = var.host_project_id
  enable_shared_vpc_service_project  = var.enable_shared_vpc_service_project
  service_project_id                 = var.service_project_id
  service_project_number             = var.service_project_number
  lookup_project_numbers             = var.lookup_project_numbers
  shared_vpc_subnets                 = var.shared_vpc_subnets
  active_apis                        = var.active_apis
  grant_services_security_admin_role = var.grant_services_security_admin_role
  grant_services_network_admin_role  = var.grant_services_network_admin_role
  grant_network_role                 = var.grant_network_role
}
