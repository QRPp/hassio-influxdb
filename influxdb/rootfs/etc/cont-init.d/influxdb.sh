#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: InfluxDB
# Configures InfluxDB
# ==============================================================================

# Configures authentication
if bashio::config.true 'auth'; then
    sed -i 's/\<auth-enabled\>.*/auth-enabled=true/' /etc/influxdb/influxdb.conf
else
    bashio::log.warning "InfluxDB authentication protection is disabled!"
    bashio::log.warning "This is NOT recommended!!!"
fi

# Configures usage reporting to InfluxDB
if bashio::config.false 'reporting'; then
    sed -i 's/\<reporting-disabled\>.*/reporting-disabled=true/' /etc/influxdb/influxdb.conf
    bashio::log.info "Reporting of usage stats to InfluxData is disabled."
fi

declare influxd_ssl=
if bashio::config.true 'influxd_ssl' &&
   bashio::config.has_value 'certfile' &&
   bashio::config.has_value 'keyfile'; then
  influxd_ssl=s
fi

# Disables external connectivity of InfluxDB
if bashio::config.true 'influxd_local_only'; then
    sed -i '/^\[http\]$/a\'$'\n''  bind-address = "127.0.0.1:8086"' /etc/influxdb/influxdb.conf
elif [ -z "${influxd_ssl}" ]; then
    bashio::log.warning 'External network connections to InfluxDB are allowed.'
    bashio::log.warning 'Given that no SSL is used, this may be a concern.'
fi

# Sets up SSL for InfluxDB
if [ -n "${influxd_ssl}" ]; then
    perl -pi \
	-e '$_ = "$`$& = true\n" if /\bhttps-enabled\b/;' \
	-e '$_ = "$`$& = \"/ssl/$certfile\"\n" if /\bhttps-certificate\b/;' \
	-e '$_ = "$`$& = \"/ssl/$keyfile\"\n" if /\bhttps-private-key\b/;' \
	-s -- \
	-certfile="$(bashio::config 'certfile')" \
	-keyfile="$(bashio::config 'keyfile')" \
	/etc/influxdb/influxdb.conf
fi
