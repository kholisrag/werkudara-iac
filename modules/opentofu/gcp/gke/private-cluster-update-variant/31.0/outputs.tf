output "gke_private_cluster_update_variant_outputs" {
  description = "Output of the GKE private cluster update variant module."
  value       = module.gke_private_cluster_update_variant
  sensitive   = true
}
