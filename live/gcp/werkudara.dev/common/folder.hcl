locals {
  gcp_org_folder_yaml = yamldecode(sops_decrypt_file("${get_repo_root()}/${get_path_from_repo_root()}/folder.enc.yaml"))
  gcp_org_folder_id   = local.gcp_org_folder_yaml.gcp_org_folder_id
  gcp_org_folder_name = local.gcp_org_folder_yaml.gcp_org_folder_name
}
