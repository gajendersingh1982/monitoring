# monitoring
 Terraform Script for creating monitoring cluster
 
### Network folder creates following resources
 - VPC
 - Subnets (Public and Private)
 - NAT Gateway
 - NACL

### Prometheus folder creates following
 - EC2
 - EIP (Attached is to EC2)
 - SG which can whitelist your publicIP --> Replace variable in sg-var with your public IP
 - It installs  Prometheus (Refer: ./Prometheus/files/setup-pdb.sh)

#### To Create full network with prometheus servers run following command in root dir
```hcl
- terraform init
- terraform plan
- terraform apply
```

:shipit:+1:
Coming up:
- Configure Grafana server
