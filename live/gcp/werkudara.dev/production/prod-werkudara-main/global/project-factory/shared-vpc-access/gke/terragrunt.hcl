locals {
  provider_vars     = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
  organization_vars = read_terragrunt_config(find_in_parent_folders("organization.hcl"))
  folder_vars       = read_terragrunt_config(find_in_parent_folders("folder.hcl"))
  project_vars      = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  gcp_project_id = local.project_vars.locals.gcp_project_id
}

terraform {
  source = format("%s/modules/opentofu/gcp/project-factory/shared-vpc-access//15.0", get_repo_root())
}

include "parent" {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = format("%s/../../../../../../common/vpc-host-prod-werkudara/global/network/vpc/vpc-prod-shared", get_terragrunt_dir())
}

inputs = {
  host_project_id                   = dependency.network.outputs.gcp_network_vpc_output.project_id
  enable_shared_vpc_service_project = true
  service_project_id                = local.gcp_project_id
  active_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudbilling.googleapis.com",
  ]
  shared_vpc_subnets = [
    dependency.network.outputs.gcp_network_vpc_output.subnets["asia-southeast1/prod-asia-southeast1"].id,
  ]
  grant_services_security_admin_role = true
}
