locals {
  organization_name        = "${basename(get_terragrunt_dir())}"
  organization_yaml        = yamldecode(sops_decrypt_file("${get_repo_root()}/${get_path_from_repo_root()}/organization.enc.yaml"))
  organization_id          = local.organization_yaml.gcp_organization_id
  organization_domain      = local.organization_yaml.gcp_domain
  organization_customer_id = local.organization_yaml.gcp_directory_customer_id
}
