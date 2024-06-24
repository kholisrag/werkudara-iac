module "gcp_google_group" {
  source  = "terraform-google-modules/group/google"
  version = "0.6.1"

  id                   = var.id
  display_name         = var.display_name
  description          = var.description
  domain               = var.domain
  customer_id          = var.customer_id
  owners               = var.owners
  managers             = var.managers
  members              = var.members
  initial_group_config = var.initial_group_config
  types                = var.types
}
