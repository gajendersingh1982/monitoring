# Monitoring Setup for small service
 Terraform Script for creating monitoring cluster
 
### Network folder creates following resources
 - VPC
 - Subnets (Public and Private)
 - NAT Gateway
 - NACL etc.

### Prometheus folder creates following
 - EC2
 - EIP (Attached is to EC2)
 - Instance Profile for auto discovery
 - SG with all trafic open within VPC
 - SG which can whitelist your publicIP --> Replace variable in sg-var with your public IP
 - Installs Prometheus (Refer: ./scripts/setup-pdb.sh)
 - Installs Node Exporter (Refer: ./scripts/setup-nodeexporter.sh)
 - Installs Grafana (Refer: ./scripts/setup-grafana.sh)

 ### open_api folder creates below
 - EC2 for testing auto discovery
 - SG with all trafic open within VPC
 - Installs Node Exporter (Refer: ./scripts/setup-nodeexporter.sh)

#### To Create full network with prometheus servers run following command in root dir
```hcl
- terraform init
- terraform plan
- terraform apply
```

:shipit: Upcoming...
- Scripts for BlackBox Exporter
- Script for JMX Exporter
- Grafana dashboards JSON foreasy install
