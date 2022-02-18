# Alkira OCI Connector - Terraform Module
This module makes it easy to provision an [OCI VCN](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingVCNs.htm) and connect it through [Alkira](htts://alkira.com).

## What it does
- Build a [VCN](https://docs.oracle.com/en-us/iaas/Content/Network/Tasks/managingVCNs.htm) and one or more subnets
- Create an [Alkira Connector](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/resources/connector_oci_vcn) for the new VCN
- Apply [Billing Tags](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/billing_tag) to the connector
- Place resources in an existing [segment](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/segment) and [group](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/group)
- Provide optional capabilities for customized routing

## Example Usage
Alkira offers enhanced capabilities for how traffic gets routed to and from _Cloud Exchange Points (CXPs)_.

### Onboard entire VCN CIDR
To onboard the entire VCN CIDR:

```hcl
module "oci_vcn" {
  source = "alkiranet/oci-vcn/alkira"

  name           = "vcn-oci-west"
  region         = "us-sanjose-1"
  cidrs          = ["10.1.0.0/16"]
  compartment_id = "oci-xxxxxxxx"

  subnets = [
    {
      name    = "subnet-01"
      cidr    = "10.1.1.0/24"
      private = "true"
    },

    {
      name    = "subnet-02"
      cidr    = "10.1.2.0/24"
      private = "true"
    }
  ]

  cxp          = "US-WEST-1"
  segment      = "corporate"
  group        = "non-prod"
  billing_tags = ["cloud", "network"]
  credential   = "oci-auth"

}
```

### Onboard specific subnets
You may also wish to onboard specific subnets. To do this, simply add **onboard_subnet = true** and add an extra **flag** key with **value** _alkira_ to the subnets you wish to onboard. You can do this with additional subnets as needed:

```hcl
module "oci_vcn" {
  source = "alkiranet/oci-vcn/alkira"

  onboard_subnet = true

  name           = "vcn-oci-west"
  region         = "us-sanjose-1"
  cidrs          = ["10.1.0.0/16"]
  compartment_id = "oci-xxxxxxxx"

  subnets = [
    {
      name    = "subnet-01"
      cidr    = "10.1.1.0/24"
      private = "true"
    },

    {
      name    = "subnet-02"
      cidr    = "10.1.2.0/24"
      private = "true"
      flag    = "alkira"
    }
  ]

  cxp          = "US-WEST-1"
  segment      = "corporate"
  group        = "non-prod"
  billing_tags = ["cloud", "network"]
  credential   = "oci-auth"

}
```

### Custom Routing
By default, Alkira will override the existing default route and route the traffic to the _CXP_. As an alternative, you can provide a list of prefixes for which traffic must be routed. This can be done by adding the option **custom_prefixes = []** to the configuration.

```hcl
module "oci_vcn" {
  source = "alkiranet/oci-vcn/alkira"

  custom_prefixes  = ["pfx-01", "pfx-02"] # Must exist in Alkira

  name           = "vcn-oci-west"
  region         = "us-sanjose-1"
  cidrs          = ["10.1.0.0/16"]
  compartment_id = "oci-xxxxxxxx"

  subnets = [
    {
      name    = "subnet-01"
      cidr    = "10.1.1.0/24"
      private = "true"
    },

    {
      name    = "subnet-02"
      cidr    = "10.1.2.0/24"
      private = "true"
    }
  ]

  cxp          = "US-WEST-1"
  segment      = "corporate"
  group        = "non-prod"
  billing_tags = ["cloud", "network"]
  credential   = "oci-auth"

}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_alkira"></a> [alkira](#requirement\_alkira) | >= 0.8.1 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >=4.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alkira"></a> [alkira](#provider\_alkira) | >= 0.8.1 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | >=4.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alkira_connector_oci_vcn.connector](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/resources/connector_oci_vcn) | resource |
| [oci_core_subnet.alkira_subnet](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.oci_subnet](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.vcn](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_vcn) | resource |
| [alkira_billing_tag.tag](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/billing_tag) | data source |
| [alkira_credential.credential](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/credential) | data source |
| [alkira_group.group](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/group) | data source |
| [alkira_policy_prefix_list.prefix](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/policy_prefix_list) | data source |
| [alkira_segment.segment](https://registry.terraform.io/providers/alkiranet/alkira/latest/docs/data-sources/segment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_tags"></a> [billing\_tags](#input\_billing\_tags) | List of billing tag names to apply to connector | `list(string)` | `[]` | no |
| <a name="input_cidrs"></a> [cidrs](#input\_cidrs) | Address space of cloud network | `list(string)` | n/a | yes |
| <a name="input_compartment_id"></a> [compartment\_id](#input\_compartment\_id) | OCI compartment ID that owns or contains calling entity | `string` | n/a | yes |
| <a name="input_credential"></a> [credential](#input\_credential) | Alkira cloud credential | `string` | n/a | yes |
| <a name="input_custom_prefixes"></a> [custom\_prefixes](#input\_custom\_prefixes) | Controls if custom prefixes are used for routing from cloud network to CXP; If values are provided, local var 'is\_custom' changes to 'true' | `list(string)` | `[]` | no |
| <a name="input_cxp"></a> [cxp](#input\_cxp) | Alkira CXP to create connector in | `string` | n/a | yes |
| <a name="input_defined_tags"></a> [defined\_tags](#input\_defined\_tags) | Predefined tags | `map(string)` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Status of connector; Default is true | `bool` | `true` | no |
| <a name="input_freeform_tags"></a> [freeform\_tags](#input\_freeform\_tags) | OCI freeform tags | `map(any)` | `{}` | no |
| <a name="input_group"></a> [group](#input\_group) | Alkira group to add connector to | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of cloud network and Alkira connector | `string` | n/a | yes |
| <a name="input_onboard_subnet"></a> [onboard\_subnet](#input\_onboard\_subnet) | Controls if subnet gets onboarded in lieu of entire cloud network | `bool` | `false` | no |
| <a name="input_primary"></a> [primary](#input\_primary) | Priority of connector; Default is true | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | Name of OCI region | `string` | n/a | yes |
| <a name="input_segment"></a> [segment](#input\_segment) | Alkira segment to add connector to | `string` | n/a | yes |
| <a name="input_size"></a> [size](#input\_size) | Alkira connector size | `string` | `"SMALL"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to create for cloud network | `list(map(string))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connector_id"></a> [connector\_id](#output\_connector\_id) | Alkira connector id |
| <a name="output_cxp"></a> [cxp](#output\_cxp) | Alkira connector CXP |
| <a name="output_name"></a> [name](#output\_name) | Network name |
| <a name="output_region"></a> [region](#output\_region) | OCI region |
| <a name="output_segment_id"></a> [segment\_id](#output\_segment\_id) | Alkira connector segment id |
| <a name="output_size"></a> [size](#output\_size) | Alkira connector size |
| <a name="output_vcn_cidr"></a> [vcn\_cidr](#output\_vcn\_cidr) | OCI VCN cidr |
| <a name="output_vcn_id"></a> [vcn\_id](#output\_vcn\_id) | OCI VCN ID |
| <a name="output_vpc_subnet"></a> [vpc\_subnet](#output\_vpc\_subnet) | Alkira subnet onboarded to CXP |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
