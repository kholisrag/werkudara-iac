locals {
  provider_vars     = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
  organization_vars = read_terragrunt_config(find_in_parent_folders("organization.hcl"))
  folder_vars       = read_terragrunt_config(find_in_parent_folders("folder.hcl"))
  project_vars      = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  gcp_project_id = local.project_vars.locals.gcp_project_id
}

terraform {
  source = format("%s/modules/opentofu/gcp/network/private-service-connect//9.1", get_repo_root())
}

include "parent" {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = format("%s/../../vpc/vpc-prod-shared", get_terragrunt_dir())
}

inputs = {
  project_id                   = local.gcp_project_id
  network_self_link            = dependency.network.outputs.gcp_network_vpc_output.network_self_link
  private_service_connect_name = "global-psc-werkudara"
  private_service_connect_ip   = "10.0.10.10"
  forwarding_rule_target       = "all-apis"
}
