# Local vars
locals {

  oci_subnets = {
    for subnet in var.subnets :
    try("${subnet.name}/${subnet.cidr}/${subnet.private}") => subnet
    if !contains(keys(subnet), "flag")
  }

  alkira_subnets = {
    for subnet in var.subnets :
    try("${subnet.name}/${subnet.cidr}/${subnet.private}/${subnet.flag}") => subnet
    if contains(keys(subnet), "flag")
  }

  # If list is not empty, set to true
  is_custom = length(var.custom_prefixes) > 0 ? true : false

  # Filter tag IDs
  tag_id_list = [
    for v in data.alkira_billing_tag.tag : v.id
  ]

  # Filter prefix IDs
  pfx_id_list = [
    for v in data.alkira_policy_prefix_list.prefix : v.id
  ]

}

/*
Alkira data sources
https://registry.terraform.io/providers/alkiranet/alkira/latest/docs
*/

data "alkira_segment" "segment" {
  name = var.segment
}

data "alkira_group" "group" {
  name = var.group
}

data "alkira_credential" "credential" {
  name = var.credential
}

data "alkira_billing_tag" "tag" {
  for_each = toset(var.billing_tags)
  name     = each.key
}

data "alkira_policy_prefix_list" "prefix" {
  for_each = toset(var.custom_prefixes)
  name     = each.key
}

resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id
  display_name   = var.name
  cidr_blocks    = var.cidrs[*]
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
}

resource "oci_core_subnet" "oci_subnet" {
  for_each = local.oci_subnets

  compartment_id            = var.compartment_id
  vcn_id                    = one(oci_core_vcn.vcn[*].id)
  display_name              = each.value.name
  cidr_block                = each.value.cidr
  prohibit_internet_ingress = each.value.private
}

resource "oci_core_subnet" "alkira_subnet" {
  for_each = local.alkira_subnets

  compartment_id            = var.compartment_id
  vcn_id                    = one(oci_core_vcn.vcn[*].id)
  display_name              = each.value.name
  cidr_block                = each.value.cidr
  prohibit_internet_ingress = each.value.private
}

resource "alkira_connector_oci_vcn" "connector" {

  # OCI values
  name       = var.name
  vcn_id     = one(oci_core_vcn.vcn[*].id)
  vcn_cidr   = var.onboard_subnet ? null : oci_core_vcn.vcn.cidr_blocks
  oci_region = var.region

  # Connector values
  enabled         = var.enabled
  primary         = var.primary
  cxp             = var.cxp
  size            = var.size
  group           = data.alkira_group.group.name
  segment_id      = data.alkira_segment.segment.id
  credential_id   = data.alkira_credential.credential.id
  billing_tag_ids = local.tag_id_list

  # If onboarding specific subnets
  dynamic "vcn_subnet" {
    for_each = {
      for subnet in oci_core_subnet.alkira_subnet : subnet.id => subnet
      if var.onboard_subnet == true
    }

    content {
      id   = vcn_subnet.value.id
      cidr = vcn_subnet.value.cidr_block
    }
  }

  /*
  Does custom bool exist?
  If yes, advertise custom prefix and pass through list
  If not, use default route and set option to route custom to null
  */
  dynamic "vcn_route_table" {
    for_each = {
      for prefix in data.alkira_policy_prefix_list.prefix : prefix.id => prefix
      if local.is_custom == true
    }

    content {
      id              = one(oci_core_vcn.vcn[*].default_route_table_id)
      options         = local.is_custom ? "ADVERTISE_CUSTOM_PREFIX" : "ADVERTISE_DEFAULT_ROUTE"
      prefix_list_ids = local.pfx_id_list
    }
  }

  depends_on = [
    oci_core_vcn.vcn,
    oci_core_subnet.oci_subnet,
    oci_core_subnet.alkira_subnet,
  ]

}
