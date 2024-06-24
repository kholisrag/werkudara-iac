locals {
  provider_vars     = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
  organization_vars = read_terragrunt_config(find_in_parent_folders("organization.hcl"))
  folder_vars       = read_terragrunt_config(find_in_parent_folders("folder.hcl"))
  project_vars      = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  provider_id = local.provider_vars.locals.provider_id
  project_id  = local.project_vars.locals.gcp_project_id
  region_id   = local.region_vars.locals.gcp_region_id

  gcp_project_id = local.project_vars.locals.gcp_project_id
  group_name     = basename(get_path_from_repo_root())
  gcp_domain     = local.organization_vars.locals.organization_domain
  customer_id    = local.organization_vars.locals.organization_customer_id

  groups_yaml = yamldecode(sops_decrypt_file("${get_repo_root()}/${get_path_from_repo_root()}/groups.enc.yaml"))
}

terraform {
  source = format("%s/modules/opentofu/gcp/group//0.6", get_repo_root())
}

generate "gcp_provider_override" {
  path      = format("%s_provider.tf", local.provider_id)
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "${local.provider_id}" {
  project               = "${local.project_id}"
  region                = "${local.region_id}"
  user_project_override = true
  billing_project       = "${local.project_id}"
}

provider "${local.provider_id}-beta" {
  project               = "${local.project_id}"
  region                = "${local.region_id}"
  user_project_override = true
  billing_project       = "${local.project_id}"
}
EOF
}

include "parent" {
  path = find_in_parent_folders()
}

inputs = {
  id           = format("%s@%s", local.group_name, local.gcp_domain)
  customer_id  = format("%s", local.customer_id)
  display_name = format("%s", local.group_name)
  description  = "GKE Security Google Groups"
  domain       = format("%s", local.gcp_domain)
  owners       = local.groups_yaml.owners
  managers     = local.groups_yaml.managers
  members      = local.groups_yaml.members
}
