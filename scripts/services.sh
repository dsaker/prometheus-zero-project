# run prometheus as a service
# https://devopscube.com/install-configure-prometheus-linux/
mv prometheus-*.linux-armv7/ prometheus-files/

sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

sudo cp prometheus-files/prometheus /usr/local/bin/
sudo cp prometheus-files/promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

sudo cp -r prometheus-files/consoles /etc/prometheus
sudo cp -r prometheus-files/console_libraries /etc/prometheus
sudo cp ~/configs/prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml

sudo cp -r ~/rules/ /etc/prometheus/rules/
sudo chown -R prometheus:prometheus /etc/prometheus/rules

sudo mv ~/services/prometheus.service /lib/systemd/system/prometheus.service

sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus.service

# run node_exporter as a service
# https://developer.couchbase.com/tutorial-node-exporter-setup
sudo groupadd -f node_exporter
sudo useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/node_exporter
sudo chown node_exporter:node_exporter /etc/node_exporter

mv node_exporter-*-armv7 node_exporter-files

sudo cp node_exporter-files/node_exporter /usr/bin/
sudo chown node_exporter:node_exporter /usr/bin/node_exporter

sudo mv ~/services/node_exporter.service /lib/systemd/system/node_exporter.service

sudo chmod 664 /usr/lib/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter.service

# run alert_manager as a service
# https://developer.couchbase.com/tutorial-configure-alertmanager
sudo groupadd -f alertmanager
sudo useradd -g alertmanager --no-create-home --shell /bin/false alertmanager
sudo mkdir -p /etc/alertmanager/templates
sudo mkdir /var/lib/alertmanager
sudo chown alertmanager:alertmanager /etc/alertmanager
sudo chown alertmanager:alertmanager /var/lib/alertmanager

mv alertmanager-*.linux-armv7/ alertmanager-files

sudo cp alertmanager-files/alertmanager /usr/bin/
sudo cp alertmanager-files/amtool /usr/bin/
sudo chown alertmanager:alertmanager /usr/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/bin/amtool

sudo cp ~/configs/alertmanager.yml /etc/alertmanager/alertmanager.yml
sudo chown alertmanager:alertmanager /etc/alertmanager/alertmanager.yml

sudo mv ~/services/alertmanager.service /lib/systemd/system/alertmanager.service

sudo chmod 664 /usr/lib/systemd/system/alertmanager.service

sudo systemctl daemon-reload
sudo systemctl start alertmanager
sudo systemctl enable alertmanager.service