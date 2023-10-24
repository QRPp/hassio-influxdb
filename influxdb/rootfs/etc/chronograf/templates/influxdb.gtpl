{
  "id": "10000",
  "name": "InfluxDB HA add-on",
  "username": "chronograf",
  "password": "{{ .secret }}",
  "url": "http{{ .ssl }}://localhost:8086",
  "type": "influx",
  "insecureSkipVerify": true,
  "default": true
}
