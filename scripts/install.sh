PROM_VERSION=2.53.0
NODE_VERSION=1.8.1
ALERT_VERSION=0.27.0

wget https://github.com/prometheus/prometheus/releases/download/v$PROM_VERSION/prometheus-$PROM_VERSION.linux-armv7.tar.gz
tar -xzf prometheus-$PROM_VERSION.linux-armv7.tar.gz
rm prometheus-$PROM_VERSION.linux-armv7.tar.gz

wget https://github.com/prometheus/node_exporter/releases/download/v$NODE_VERSION/node_exporter-$NODE_VERSION.linux-armv7.tar.gz
tar -xzf node_exporter-$NODE_VERSION.linux-armv7.tar.gz
rm node_exporter-$NODE_VERSION.linux-armv7.tar.gz

wget https://github.com/prometheus/alertmanager/releases/download/v$ALERT_VERSION/alertmanager-$ALERT_VERSION.linux-armv7.tar.gz
tar -xzf alertmanager-$ALERT_VERSION.linux-armv7.tar.gz
rm alertmanager-$ALERT_VERSION.linux-armv7.tar.gz

# https://grafana.com/tutorials/install-grafana-on-raspberry-pi/
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo /bin/systemctl enable grafana-server
sudo /bin/systemctl start grafana-server