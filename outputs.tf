output "name" {
  description = "Network name"
  value       = var.name
}

output "vcn_id" {
  description = "OCI VCN ID"
  value       = oci_core_vcn.vcn.id
}

output "vcn_cidr" {
  description = "OCI VCN cidr"
  value       = oci_core_vcn.vcn.cidr_blocks
}

output "region" {
  description = "OCI region"
  value       = var.region
}

output "connector_id" {
  description = "Alkira connector id"
  value       = alkira_connector_oci_vcn.connector.id
}

output "cxp" {
  description = "Alkira connector CXP"
  value       = alkira_connector_oci_vcn.connector.cxp
}

output "size" {
  description = "Alkira connector size"
  value       = alkira_connector_oci_vcn.connector.size
}

output "segment_id" {
  description = "Alkira connector segment id"
  value       = alkira_connector_oci_vcn.connector.segment_id
}

output "vpc_subnet" {
  description = "Alkira subnet onboarded to CXP"
  value       = try(alkira_connector_oci_vcn.connector.vcn_subnet)
}
