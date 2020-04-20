#!/bin/sh

. ./grafana-lib.sh

DATASOURCE_NAME=Prometheus
DATASOURCE_TYPE=Prometheus
GRAPHITE_URL=http://localhost:9090/

setup() {
  if grafana_has_data_source ${DATASOURCE_NAME}; then
    info "Prometheus: Data source already exists"
  else
    if grafana_create_data_source ${DATASOURCE_NAME} ${DATASOURCE_TYPE} ${GRAPHITE_URL}; then
      success "Prometheus: Data source ${DATASOURCE_NAME} created"
    else
      error "Prometheus: Data source ${DATASOURCE_NAME} could not be created"
    fi
  fi
}

setup

