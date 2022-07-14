## Customized routing
By default, Alkira will override the existing default route and route the traffic to the _CXP_. As an alternative, you can provide a list of prefixes for which traffic must be routed. You can also enable direct _inter-vpc_ communication.

### Usage
Add the option **custom_prefixes = []** to the configuration. These prefixes must already exist in Alkira. For direct _inter-vpc_ communication, add **direct_inter_vpc = true**. Both cannot be enabled at the same time.

```bash
$ terraform init
$ terraform plan
$ terraform apply
```