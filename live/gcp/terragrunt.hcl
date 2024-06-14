locals {
  provider_vars = read_terragrunt_config(find_in_parent_folders("provider.hcl"),

  )
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"),
    {
      gcp_project_id = "default"
    },
  )
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"),
    {
      gcp_region_id = "default"
    },
  )

  provider_id = local.provider_vars.locals.provider_id
  project_id  = local.project_vars.locals.gcp_project_id
  region_id   = local.region_vars.locals.gcp_region_id
}

generate "gcp_provider" {
  path      = format("%s_provider.tf", local.provider_id)
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "${local.provider_id}" {
  project = "${local.project_id}"
  region  = "${local.region_id}"
}
EOF
}

remote_state {
  backend = "gcs"
  config = {
    project  = local.project_id
    location = local.region_id
    bucket   = format("%s-%s-terraform-remote-state", local.project_id, local.region_id)
    prefix   = format("gcp/%s", path_relative_to_include())

    gcs_bucket_labels = {
      terragrunt = "true"
      terraform  = "true"
      component  = "terraform-remote-state"
    }
  }
  generate = {
    path      = "gcs_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform {
  extra_arguments "add_signatures_for_other_platforms" {
    commands = contains(get_terraform_cli_args(), "lock") ? ["providers"] : []
    env_vars = {
      TF_CLI_ARGS_providers_lock = "-platform=linux_amd64 -platform=linux_arm64 -platform=darwin_arm64 -platform=darwin_amd64"
    }
  }
}

retry_max_attempts       = 30
retry_sleep_interval_sec = 10
retryable_errors = [
  ".*net/http: TLS handshake timeout.*",
  ".*dial.*connect: connection refused.*",
  ".*read: connection reset by peer.*",
  ".*read: connection timed out.*",
  ".*Error installing provider.*connection reset by peer.*",
  ".*Error while installing.*tcp.*i/o timeout.*",
  ".*Error while installing.*could not query provider.*",
  ".*Error while installing.*exceeded while awaiting headers.*",
  ".*ssh_exchange_identification.*Connection closed by remote host.*",
  ".*failed to create kubernetes rest client for update of resource.*",
  ".*Could not retrieve the list of available versions for provider.*",
  ".*context deadline exceeded.*",
  ".*Failed to retrieve available versions for module.*",
  ".*When expanding the plan for.*to include new values learned so far during apply, provider.*changed the planned action from NoOp to Create.*",
  ".*Terraform failed to fetch the requested providers for.*",
  ".*Error building changeset.*but it already exists.*",
  ".*If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry.*"
]
