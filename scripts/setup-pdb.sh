#!/usr/bin/env bash

# It runs on host startup.
# Log everything we do.
set -x
exec >> /var/log/user-data-pdb.log 2>&1

sudo apt-get update -y

sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

curl -LO https://github.com/prometheus/prometheus/releases/download/v2.17.1/prometheus-2.17.1.linux-amd64.tar.gz
tar -xvf prometheus-2.17.1.linux-amd64.tar.gz
mv prometheus-2.17.1.linux-amd64 prometheus-files

sudo cp prometheus-files/prometheus /usr/local/bin/
sudo cp prometheus-files/promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

sudo cp -r prometheus-files/consoles /etc/prometheus
sudo cp -r prometheus-files/console_libraries /etc/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

#Create the prometheus.yml file.
touch /etc/prometheus/prometheus.yml

FILE="/etc/prometheus/prometheus.yml"

# edit prometheus config file for the PDB server
/bin/cat <<EOM >$FILE
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 10s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node-exporter'
    scrape_interval: 10s
    ec2_sd_configs:
      - region: us-east-1
        port: 9100
    relabel_configs:
        # Only monitor instances with a Name starting with "tf-tokyo-dev-galaxy-badge-"
      - source_labels: [__meta_ec2_tag_Name]
        regex: tf-tokyo-dev-galaxy-badge-.*
        action: keep
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance
EOM

#Change the ownership of the file to prometheus user
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

#Register this as service
## add prometheus as a service ##
touch /etc/systemd/system/prometheus.service

FILE="/etc/systemd/system/prometheus.service"

# edit prometheus service file for the PDB server
/bin/cat <<EOM >$FILE
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
 
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries
 
[Install]
WantedBy=multi-user.target
EOM

# reload deamon and start service 
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
