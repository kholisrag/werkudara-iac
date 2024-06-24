locals {
  provider_vars     = read_terragrunt_config(find_in_parent_folders("provider.hcl"))
  organization_vars = read_terragrunt_config(find_in_parent_folders("organization.hcl"))
  folder_vars       = read_terragrunt_config(find_in_parent_folders("folder.hcl"))
  project_vars      = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  gcp_project_id = local.project_vars.locals.gcp_project_id
  cluster_name   = basename(get_path_from_repo_root())
}

terraform {
  source = format("%s/modules/opentofu/gcp/gke/private-cluster-update-variant//31.0", get_repo_root())
}

include "parent" {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = format("%s/../../../../../common/vpc-host-prod-werkudara/global/network/vpc/vpc-prod-shared", get_terragrunt_dir())
}

dependency "gke_security_groups" {
  config_path = format("%s/../../../../../common/vpc-host-prod-werkudara/global/group/gke-security-groups", get_terragrunt_dir())
}

inputs = {
  project_id = local.gcp_project_id

  name                = local.cluster_name
  description         = "GKE cluster for production environment"
  kubernetes_version  = "latest"
  release_channel     = "REGULAR"
  deletion_protection = false

  regional = false
  zones = [
    "asia-southeast1-b",
  ]

  master_ipv4_cidr_block       = "10.0.100.0/28"
  master_global_access_enabled = true

  deploy_using_private_endpoint = false
  enable_private_endpoint       = false
  enable_private_nodes          = true

  network            = dependency.network.outputs.gcp_network_vpc_output.network_name
  network_project_id = dependency.network.outputs.gcp_network_vpc_output.project_id
  subnetwork         = dependency.network.outputs.gcp_network_vpc_output.subnets["asia-southeast1/prod-asia-southeast1"].name
  master_authorized_networks = [
    {
      display_name = "vpc-host-prod-werkudara-asia-southeast1"
      cidr_block   = dependency.network.outputs.gcp_network_vpc_output.subnets["asia-southeast1/prod-asia-southeast1"].ip_cidr_range
    }
  ]

  ip_range_pods            = "gke-pods"
  additional_ip_range_pods = []
  ip_range_services        = "gke-services"

  datapath_provider   = "ADVANCED_DATAPATH"
  gateway_api_channel = "CHANNEL_STANDARD"
  dns_cache           = true
  network_policy      = false // use GKE Dataplane V2 with datapath_provider - cillium

  monitoring_enable_managed_prometheus = false
  monitoring_enabled_components        = []
  monitoring_service                   = "none"

  logging_enabled_components = []
  logging_service            = "none"

  maintenance_start_time = "2024-01-01T19:00:00Z"
  maintenance_end_time   = "2024-01-02T11:00:00Z"
  maintenance_recurrence = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"

  add_cluster_firewall_rules        = true
  add_master_webhook_firewall_rules = true

  enable_confidential_nodes           = false
  security_posture_mode               = "BASIC"
  security_posture_vulnerability_mode = "VULNERABILITY_DISABLED"
  enable_shielded_nodes               = true

  identity_namespace           = "enabled"
  authenticator_security_group = dependency.gke_security_groups.outputs.gcp_google_group_output.id
  grant_registry_access        = true
  create_service_account       = true
  service_account_name         = "gke-prod-werkudara-iam-sa"

  remove_default_node_pool = true
  node_pools = [
    {
      name         = "spot-n1-standard-1"
      machine_type = "n1-standard-1"
      spot         = true
      auto_upgrade = true
      auto_repair  = true
      autoscaling  = true
      min_count    = 1
      max_count    = 2
      disk_size_gb = 20
      disk_type    = "pd-ssd"
      image_type   = "COS_CONTAINERD"
      enable_gcfs  = true
      enable_gvnic = true
    },
  ]
  node_pools_labels = {
    all = {
      "gke-cluster" = local.cluster_name
      "terragrunt"  = "true"
      "terraform"   = "true"
    }
  }
  node_pools_resource_labels = {
    all = {
      "kubernetes"  = "true"
      "gke"         = "true"
      "gke-cluster" = local.cluster_name
      "terragrunt"  = "true"
      "terraform"   = "true"
    }
  }
  node_pools_metadata = {
    all = {
      shutdown-script = "kubectl --kubeconfig=/var/lib/kubelet/kubeconfig drain --force=true --ignore-daemonsets=true --delete-emptydir-data=true \"$HOSTNAME\""
    }
  }
  node_pools_taints = {
    all = []
  }
  node_pools_tags = {
    all = [
      "gke",
      "gke-cluster",
      local.cluster_name,
    ]
  }
  network_tags = [
    "gke",
    "gke-cluster",
    local.cluster_name,
  ]

  cluster_resource_labels = {
    "kubernetes"  = "true"
    "gke"         = "true"
    "gke-cluster" = local.cluster_name
    "terragrunt"  = "true"
    "terraform"   = "true"
  }
}
