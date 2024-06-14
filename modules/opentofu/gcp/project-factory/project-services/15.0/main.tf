module "gcp_project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "15.0.1"

  project_id                  = var.project_id
  enable_apis                 = var.enable_apis
  activate_apis               = var.activate_apis
  activate_api_identities     = var.activate_api_identities
  disable_services_on_destroy = var.disable_services_on_destroy
  disable_dependent_services  = var.disable_dependent_services
}
