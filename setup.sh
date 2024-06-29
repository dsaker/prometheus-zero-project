sudo apt update

sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile
sudo sed -i -e 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/g' /etc/dphys-swapfile
CONF_SWAPSIZE=1024
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
sudo reboot

sudo apt upgrade

wget https://github.com/prometheus/prometheus/releases/download/v2.53.0/prometheus-2.53.0.linux-armv7.tar.gz
tar -xzf prometheus-2.53.0.linux-armv7.tar.gz
rm prometheus-2.53.0.linux-armv7.tar.gz

# https://devopscube.com/install-configure-prometheus-linux/
mv prometheus-2.53.0.linux-armv7/ prometheus-files/

sudo cp prometheus-files/prometheus /usr/local/bin/
sudo cp prometheus-files/promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

sudo cp -r prometheus-files/consoles /etc/prometheus
sudo cp -r prometheus-files/console_libraries /etc/prometheus
sudo cp -r prometheus-files/prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

sudo vi /etc/systemd/system/prometheus.service

sudo systemctl daemon-reload
sudo systemctl start prometheus

sudo systemctl status prometheus
sudo systemctl enable prometheus.service

ifconfig

wget https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-armv7.tar.gz
tar -xzf node_exporter-1.8.1.linux-armv7.tar.gz

# https://developer.couchbase.com/tutorial-node-exporter-setup
sudo groupadd -f node_exporter
sudo useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/node_exporter
sudo chown node_exporter:node_exporter /etc/node_exporter
mv node_exporter-1.8.1.linux-armv7 node_exporter-files

sudo cp node_exporter-files/node_exporter /usr/bin/
sudo chown node_exporter:node_exporter /usr/bin/node_exporter

sudo vi /usr/lib/systemd/system/node_exporter.service

sudo chmod 664 /usr/lib/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl start node_exporter

sudo systemctl enable node_exporter.service


wget https://github.com/prometheus/alertmanager/releases/download/v0.27.0/alertmanager-0.27.0.linux-armv7.tar.gz
tar -xzf alertmanager-0.27.0.linux-armv7.tar.gz

# https://grafana.com/tutorials/install-grafana-on-raspberry-pi/
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo /bin/systemctl enable grafana-server
sudo /bin/systemctl start grafana-server
