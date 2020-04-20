# Simple bash script to wire up Grafana 2.x with graphite and add dashboards

This Bash script exposes a few functions to create a Grafana data source,
like graphite.

Also allows to upload some dashboards.

## Usage

```
$ ./grafana-graphite-wiring.sh
```

Will setup graphite in localhost

```
$ ./grafana-upload-dashboard.sh dashboard.json [...]
```

Will upload the given dashboard to graphana.

# Example: Add a pair of dashboards for CF directly from a gist:

```
./grafana-upload-dashboard.sh <(curl -qs https://gist.githubusercontent.com/keymon/80c8992c803f2192dab3/raw/1ce4c8a06d6f919d656c598218148b2ab0bd3589/cf_services_metrics.json) <(curl -qs https://gist.githubusercontent.com/keymon/80c8992c803f2192dab3/raw/1ce4c8a06d6f919d656c598218148b2ab0bd3589/cf_specific_job_metrics.json)

```

# Credits

based on grafana+influx setup code from leehambley/README.md
