#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: InfluxDB
# Configures influxdb.src for Chronograf
# ==============================================================================

declare influxd_ssl=
if bashio::config.true 'influxd_ssl' &&
   bashio::config.has_value 'certfile' &&
   bashio::config.has_value 'keyfile'; then
  influxd_ssl=s
fi

bashio::var.json \
    secret "$(</data/secret)" \
    ssl "${influxd_ssl}" \
    | tempio \
        -template /etc/chronograf/templates/influxdb.gtpl \
        -out /etc/chronograf/influxdb.src
