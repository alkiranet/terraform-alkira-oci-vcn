module "oci_vcn" {
  source = "alkiranet/oci-vcn/alkira"

  name           = "vcn-west"
  region         = "us-sanjose-1"
  cidrs          = ["10.1.0.0/16"]
  compartment_id = "oci-xxxxxxxx"

  subnets = [
    {
      name    = "app-subnet-a"
      cidr    = "10.1.1.0/24"
      private = "true"
    },
    {
      name    = "app-subnet-b"
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