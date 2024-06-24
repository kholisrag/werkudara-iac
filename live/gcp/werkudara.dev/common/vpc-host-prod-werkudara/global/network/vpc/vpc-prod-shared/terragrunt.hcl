locals {
  provider_vars     = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
  organization_vars = read_terragrunt_config(find_in_parent_folders("organization.hcl"))
  folder_vars       = read_terragrunt_config(find_in_parent_folders("folder.hcl"))
  project_vars      = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  gcp_project_id = local.project_vars.locals.gcp_project_id
}

terraform {
  source = format("%s/modules/opentofu/gcp/network/vpc//9.1", get_repo_root())
}

include "parent" {
  path = find_in_parent_folders()
}

inputs = {
  project_id   = local.gcp_project_id
  network_name = "vpc-prod-shared"

  auto_create_subnetworks = false
  mtu                     = 0 // equal to default to 1460
  routing_mode            = "GLOBAL"
  shared_vpc_host         = true

  subnets = [
    {
      subnet_name   = "proxy-only-prod-asia-southeast1"
      subnet_ip     = "10.253.0.0/16"
      subnet_region = "asia-southeast1"
      role          = "ACTIVE"
      purpose       = "REGIONAL_MANAGED_PROXY"
    },
    {
      subnet_name           = "prod-asia-southeast1"
      subnet_ip             = "10.1.0.0/16"
      subnet_region         = "asia-southeast1"
      subnet_private_access = true
    },
    {
      subnet_name           = "prod-asia-southeast2"
      subnet_ip             = "10.2.0.0/16"
      subnet_region         = "asia-southeast2"
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "prod-asia-southeast1" = [
      {
        range_name    = "gke-pods"
        ip_cidr_range = "10.100.0.0/14"
      },
      {
        range_name    = "gke-services"
        ip_cidr_range = "10.104.0.0/16"
      },
    ]
  }

  ingress_rules = [
    {
      name     = "vpc-prod-shared-allow-ssh"
      priority = 10000
      // log_config = {
      //   metadata = "INCLUDE_ALL_METADATA"
      // }
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      source_ranges = [
        "35.235.240.0/20",
      ]
    },
  ]
}

prevent_destroy = true
