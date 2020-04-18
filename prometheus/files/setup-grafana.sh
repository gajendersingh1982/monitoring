#!/usr/bin/env bash

# It runs on host startup.
# Log everything we do.
set -x
exec >> /var/log/user-data-pdb.log 2>&1

sudo apt-get update -y

# Install Grafana
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_6.7.2_amd64.deb
sudo dpkg -i grafana_6.7.2_amd64.deb

# reload deamon and start service 
sudo systemctl daemon-reload 
sudo systemctl enable grafana-server 
sudo systemctl start grafana-server
