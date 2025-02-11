#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: InfluxDB
# Configures Kapacitor.conf
# ==============================================================================

declare influxd_ssl=
if bashio::config.true 'influxd_ssl' &&
   bashio::config.has_value 'certfile' &&
   bashio::config.has_value 'keyfile'; then
  influxd_ssl=s
fi

bashio::var.json \
    reporting "^$(bashio::config 'reporting')" \
    secret "$(</data/secret)"\
    ssl "${influxd_ssl}" \
    | tempio \
        -template /etc/kapacitor/templates/kapacitor.gtpl \
        -out /etc/kapacitor/kapacitor.conf
