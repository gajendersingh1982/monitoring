#!/usr/bin/env bash

# It runs on host startup.
# Log everything we do.
set -x
exec >> /var/log/user-data-node_exporter.log 2>&1

sudo apt-get update -y

sudo useradd --no-create-home --shell /bin/false node_exporter

curl -LO https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz
tar xvf node_exporter-${node_exporter_version}.linux-amd64.tar.gz
sudo cp node_exporter-${node_exporter_version}.linux-amd64/node_exporter /usr/local/bin
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-${node_exporter_version}.linux-amd64.tar.gz node_exporter-${node_exporter_version}.linux-amd64

#Register this as service
## add prometheus as a service ##
touch /etc/systemd/system/node_exporter.service

FILE="/etc/systemd/system/node_exporter.service"

# edit prometheus service file for the PDB server
/bin/cat <<EOM >$FILE
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOM

# reload deamon and start service 
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# wget https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz
# tar xvfz node_exporter-${node_exporter_version}.linux-amd64.tar.gz

# nohup ./node_exporter-${node_exporter_version}.linux-amd64/node_exporter >> /var/log/nodeexporter.log &