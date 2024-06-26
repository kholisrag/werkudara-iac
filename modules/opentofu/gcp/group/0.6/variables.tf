variable "id" {
  type        = string
  description = "ID of the group. For Google-managed entities, the ID must be the email address the group"
}

variable "display_name" {
  type        = string
  description = "Display name of the group"
  default     = ""
}

variable "description" {
  type        = string
  description = "Description of the group"
  default     = ""
}

variable "domain" {
  type        = string
  description = "Domain of the organization to create the group in. One of domain or customer_id must be specified"
  default     = ""
}

variable "customer_id" {
  type        = string
  description = "Customer ID of the organization to create the group in. One of domain or customer_id must be specified"
  default     = ""
}

variable "owners" {
  type        = list(string)
  description = "Owners of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account"
  default     = []
}

variable "managers" {
  type        = list(string)
  description = "Managers of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account"
  default     = []
}

variable "members" {
  type        = list(string)
  description = "Members of the group. Each entry is the ID of an entity. For Google-managed entities, the ID must be the email address of an existing group, user or service account"
  default     = []
}

variable "initial_group_config" {
  type        = string
  description = "The initial configuration options for creating a Group. See the API reference for possible values. Possible values are INITIAL_GROUP_CONFIG_UNSPECIFIED, WITH_INITIAL_OWNER, and EMPTY."
  default     = "EMPTY"
}

variable "types" {
  type        = list(string)
  description = "The type of the group to be created. More info: https://cloud.google.com/identity/docs/groups#group_properties"
  default     = ["default"]
  validation {
    condition = alltrue(
      [for t in var.types : contains(["default", "dynamic", "security", "external"], t)]
    )
    error_message = "Valid values for group types are \"default\", \"dynamic\", \"security\", \"external\"."
  }
}
