## Onboard specific subnets
The following example configuration will onboard specific subnets.

### Usage
To use this example, fill in the appropriate values in _variables.tf_ and provide those values _(including any secrets)_ by way of _terraform.tfvars_ or desired secrets management platform. Add **onboard_subnet = true** and add **flag = "alkira"** to the subnets you wish to onboard. Then run:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```