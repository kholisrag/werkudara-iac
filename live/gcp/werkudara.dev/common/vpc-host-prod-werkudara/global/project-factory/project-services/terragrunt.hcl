locals {
  provider_vars     = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
  organization_vars = read_terragrunt_config(find_in_parent_folders("organization.hcl"))
  folder_vars       = read_terragrunt_config(find_in_parent_folders("folder.hcl"))
  project_vars      = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  gcp_project_id = local.project_vars.locals.gcp_project_id
}

terraform {
  source = format("%s/modules/opentofu/gcp/project-factory/project-services//15.0", get_repo_root())
}

include "parent" {
  path = find_in_parent_folders()
}

inputs = {
  project_id  = local.gcp_project_id
  enable_apis = true
  activate_apis = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "dns.googleapis.com",
  ]
  disable_services_on_destroy = false
  disable_dependent_services  = false
}
