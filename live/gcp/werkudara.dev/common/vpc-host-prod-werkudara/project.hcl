locals {
  gcp_project_yaml            = yamldecode(sops_decrypt_file("${get_repo_root()}/${get_path_from_repo_root()}/project.enc.yaml"))
  gcp_project_name            = local.gcp_project_yaml.gcp_project_name
  gcp_project_id              = local.gcp_project_yaml.gcp_project_id
  gcp_project_billing_account = local.gcp_project_yaml.gcp_project_billing_account
}
