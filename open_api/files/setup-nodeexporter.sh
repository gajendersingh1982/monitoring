#!/usr/bin/env bash

# It runs on host startup.
# Log everything we do.
set -x
exec >> /var/log/user-data-pdb.log 2>&1

sudo apt-get update -y
wget https://github.com/prometheus/node_exporter/releases/download/${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz
tar xvfz node_exporter-${node_exporter_version}.linux-amd64.tar.gz

nohup ./node_exporter-${node_exporter_version}.linux-amd64/node_exporter >> /var/log/nodeexporter.log &