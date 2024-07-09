# Measuring IoT and Setting Alerts Using Raspberry Pi Zero - DHT - Prometheus - Grafana

### Hardware

- Raspberry Pi.
  - Tested with Raspberry Pi Zero 2W.
- ESP8266-based board (or some other appropriate Arduino-based board).
  - Tested with WEMOS D1 Mini.
- DHT sensor.
  - Tested with DHT22
- 32GB or 64GB microSD card
- Three micro usb chargers

## Sensor Setup

- Follow directions at -> https://github.com/HON95/prometheus-esp8266-dht-exporter
- In the arduino folder contained in this repository Fahrenheit temperature has been added to the exported metrics
- Please note that WIFI_IPV4_ADDRESS is hardcoded and must be changed manually in config.h for each sensor
  - To align with prometheus.yml you would need three sensors with values ['192.168.1.15', '192.168.1.16', '192.168.1.17']
  - Change these values in prometheus.yml if they are different

## Raspberry Pi Setup

- Install Raspberry Pi OS with [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
  - Choose Raspberry Pi OS (other) > Raspberry Pi OS Lite (64 bit) with no desktop environment
  - EDIT SETTINGS
    - GENERAL: Set username and password > Enable hostname (raspberrypi.local) > Configure wireless LAN > Set locale
    - SERVICES: Enable SSH (if you are doing this a second time you either have to change the hostname in GENERAL or delete rapsberrypi.local from ~/.ssh/known_hosts)

## Setup Using Ansible

- Change raspberrypi_hostname and username to values used in Rasperry Pi Setup
- If using Raspberry Pi Zero 2W change swapsize
  - Run `make connect` from repository root folder
    - Once connected run:
    ```
      sudo dphys-swapfile swapoff 
      sudo sed -i -e 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/g' /etc/dphys-swapfile
      sudo dphys-swapfile setup
      sudo dphys-swapfile swapon
      sudo reboot
    ```
- install ansible (https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- `cd ansible`
- change sensor names and ansible_user in inventory.txt file to desired values
- `cp alertmanager/vars/main.yml.bak alertmanager/vars/main.yml`
- create gmail account to send alerts as explained in next section and define smtp_* vars in alertmanager/vars/main.yml file
- run `ansible-playbook -i inventory.txt playbook.yml`
- update rules/sensor-rules.yml to set alerts where you desire and run `make prom/rules` from repository root directory
  
## Install and Configure Software Using SSH

- Set variables ['raspberrypi_hostname', 'username'] in Makefile
- Run `cp configs/alertmanager.yml.bak configs/alertmanager.yml`
  - Enable IMAP on gmail account -> https://support.google.com/a/answer/105694?hl=en
  - Get App Password -> https://support.google.com/mail/answer/185833?hl=en
  - Replace these values in alertmanager.yml
- Run `make copyfiles` (copies all files from this repository on to the Raspberry Pi)
- Run `make connect` (ssh's into Rapsberry Pi)
- Once connected
  - `chmod -R +x scripts`
  - `cd scripts`
  - `sudo apt update`
  - If using Raspberry Pi Zero 2W run `./swapsize.sh`
    - Increases swapsize value
    - Necessary to run `sudo apt upgrade` - connection will be closed on reboot - run `make connect` again
  - `./install.sh`
    - change version variable at top of bash script if you want to install a different version
    - installs prometheus, alertmanager, node_exporter, and grafana
  - `./services.sh`
    - runs prometheus, alertmanager, and node exporter as services for increased robustness (grafana is already a service)
- UI's
  - prometheus -> http://raspberrypi.local:9090/
  - alertmanager -> http://raspberrypi.local:9093/
  - grafana -> http://raspberrypi.local:3000/
  - node_exporter -> http://raspberrypi.local:9200/
  - if UI is not loading check logs in raspberry pi `systemctl status <service>` and `journal ctl -u <service>`

## Grafana Setup

- login at grafana ui with admin, admin
- change password if desired
- click on Connections > Add new connection > Add Prometheus and Alertmanger data sources
  - https://grafana.com/docs/grafana/latest/datasources/prometheus/configure-prometheus-data-source/
- go to -> https://grafana.com/grafana/dashboards/ to find Node Exporter Full and Alertmanager dashboards
  - Add them by clicking on Dashboards > New > Import
  - https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/import-dashboards/
  - import config/example_dashboard.json

## Updating configs/rules

- to make changes to prometheus.yml you can make changes locally and run `make prom/config`
- the same is true for configs/alertmanager.yml (`make alert/config`) and rules/* `make prom/rules`
- update the rules to desired values and run make command to update
- run `make help` to list all available make commands

## License

GNU General Public License version 3 (GPLv3).